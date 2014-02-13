require "law/japan"

require "git"
require "logger"

class Law::Japan::EGov
  SourceDir = File.join(Dir.home, ".law-japan")

  HtmlRepoURL = "git@github.com:riywo/law-japan-e_gov-html.git"
  TextRepoURL = "git@github.com:riywo/law-japan-e_gov-text.git"

  def initialize
    FileUtils.mkdir_p SourceDir
  end

  def update!
    html_git.pull
    text_git.pull
  end

  def download!
    Downloader.new(html_data_dir).download!
  end

  def convert!
    Converter.new(html_data_dir, text_data_dir).convert!
  end

  private

  def html_data_dir
    File.join(html_git.dir.path, "data")
  end

  def text_data_dir
    File.join(text_git.dir.path, "data")
  end

  def git_open_or_clone(repo_url, name)
    Git.open(File.join(SourceDir, name), log: Logger.new(STDOUT))
  rescue
    Git.clone(repo_url, name, path: SourceDir, log: Logger.new(STDOUT))
  end

  def html_git
    @html_git ||= git_open_or_clone(HtmlRepoURL, "html")
  end

  def text_git
    @text_git ||= git_open_or_clone(TextRepoURL, "text")
  end
end

require "law/japan/e_gov/downloader"
require "law/japan/e_gov/converter"
