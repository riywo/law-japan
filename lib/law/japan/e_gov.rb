require "law/japan"

require "git"
require "logger"

class Law::Japan::EGov
  SourceDir = File.join(Dir.home, ".law-japan")

  HtmlRepoURL = "git@github.com:riywo/law-japan-e_gov-html.git"
  TextRepoURL = "git@github.com:riywo/law-japan-e_gov-text.git"

  def initialize(logger: nil)
    FileUtils.mkdir_p SourceDir
    @logger = logger
  end

  def update!
    html_git.pull
    text_git.pull
    true
  end

  def download!
    Downloader.new(html_data_dir, logger: logger).download!
  end

  def convert!
    Converter.new(html_data_dir, text_data_dir, logger: logger).convert!
  end

  private

  def html_data_dir
    File.join(html_git.dir.path, "data")
  end

  def text_data_dir
    File.join(text_git.dir.path, "data")
  end

  def git_open_or_clone(repo_url, name)
    Git.open(File.join(SourceDir, name), log: logger)
  rescue
    Git.clone(repo_url, name, path: SourceDir, log: logger)
  end

  def html_git
    @html_git ||= git_open_or_clone(HtmlRepoURL, "html")
  end

  def text_git
    @text_git ||= git_open_or_clone(TextRepoURL, "text")
  end

  def logger
    @logger ||= Logger.new(STDOUT)
  end
end

require "law/japan/e_gov/downloader"
require "law/japan/e_gov/converter"
