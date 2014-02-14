require "law/japan/e_gov"
require "mechanize"

class Law::Japan::EGov::Downloader
  module Mechanize::Form::Clearable
    refine Mechanize::Form do
      def clear_buttons
        @clicked_buttons = []
      end
    end
  end
  using Mechanize::Form::Clearable

  attr_reader :root_dir
  def initialize(root_dir, logger: nil)
    @root_dir = root_dir
    @logger   = logger
  end

  def download!
    logger.info "Start downloading all laws"
    download
    logger.info "Finish downloading all laws"
    true
  end

  private

  def logger
    @logger ||= Logger.new STDOUT
  end

  def agent
    unless @agent
      @agent = Mechanize.new { |a| a.user_agent_alias = "Windows IE 9" }
      @agent.log = Logger.new STDOUT
    end
    @agent
  end

  def index_page
    @index_page ||= agent.get("http://law.e-gov.go.jp/cgi-bin/idxsearch.cgi")
  end

  def category_form
    index_page.forms_with(name: "index")[2]
  end

  def download
    category_form.buttons.each do |button|
      category_name = button.node.next.text.gsub(/[ 　]+/, "")

      category_form.clear_buttons
      list_page = agent.submit(category_form, button)
      sleep 1

      list_page.links.each do |link|
        law_name = link.text
        h_file_name = CGI.parse(link.uri.query)["H_FILE_NAME"].first
        if h_file_name =~ /^([MTSH]\d{2})/
          law_url = "http://law.e-gov.go.jp/htmldata/#{$1}/#{h_file_name}.html"
          law_file = File.join(root_dir, category_name, "#{h_file_name}.html")
          if File.exists? law_file
            logger.info "File already exists for #{law_name} (#{law_file})"
          else
            logger.info "Start downloading for #{law_name} (url: #{law_url}, file: #{law_file})"
             agent.download(law_url, law_file)
            logger.info "Finish downloading for #{law_name} (url: #{law_url}, file: #{law_file})"
             sleep 2
          end
        else
          logger.warn "Invalid H_FILE_NAME #{h_file_name} for #{law_file}"
        end
      end
    end
  end
end
