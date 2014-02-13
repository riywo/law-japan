require "law/japan/e_gov"
require "find"
require "nokogiri"
require "logger"

class Law::Japan::EGov::Converter
  attr_reader :html_dir, :text_dir

  def initialize(html_dir, text_dir)
    @html_dir = html_dir
    @text_dir = text_dir
  end

  def convert!
    logger.info "Start converting all laws"
    convert
    logger.info "Finish converting all laws"
  end

  private

  def logger
    @logger ||= Logger.new STDOUT
  end

  def convert
    Dir.chdir(html_dir) do
      Dir.glob(File.join("**", "*.html")) do |path|
        convert_html(path)
      end
    end
  end

  def convert_html(path)
    dirname = File.dirname(path)
    basename = File.basename(path, ".html")
    target_dir = File.join(text_dir, dirname)
    target_file = File.join(target_dir, "#{basename}.txt")
    logger.info "Converting to #{target_file}"

    FileUtils.mkdir_p target_dir
    text = Nokogiri::HTML(open(path)).css("body").first.text
    File.write(target_file, text)
  end
end
