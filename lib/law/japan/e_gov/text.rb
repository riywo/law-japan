require "law/japan/e_gov"

require "find"
require "nokogiri"

class Law::Japan::EGov::Text < Law::Japan::EGov
  RepoDir = File.join(HomeDir, "update", "text")
  RepoURL = "git@github.com:riywo/law-japan-e_gov-text.git"

  def initialize(html_data_dir, repo_dir: nil, repo_url: nil, logger: nil)
    @html_data_dir = html_data_dir
    super(repo_dir: repo_dir, repo_url: repo_url, logger: logger)
  end

  def convert!
    @logger.info "Start converting all laws"
    Dir.chdir(@html_data_dir) do
      Dir.glob(File.join("**", "*.html")) do |path|
        convert_html(path)
      end
    end
    @logger.info "Finish converting all laws"
    true
  end

  private

  def convert_html(path)
    dirname = File.dirname(path)
    basename = File.basename(path, ".html")
    target_dir = File.join(data_dir, dirname)
    target_file = File.join(target_dir, "#{basename}.txt")
    @logger.info "Converting to #{target_file}"

    FileUtils.mkdir_p target_dir
    text = Nokogiri::HTML(open(path)).css("body").first.text
    File.write(target_file, text)
  end
end
