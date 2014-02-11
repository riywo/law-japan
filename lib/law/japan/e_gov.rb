require "law/japan"

require "git"
require "logger"

class Law::Japan::EGov
  SourceDir = File.join(Dir.home, ".law-japan")

  HtmlRepoURL = "file:///tmp/law-japan-e_gov-html"
  TextRepoURL = "file:///tmp/law-japan-e_gov-text"

  def initialize
    FileUtils.mkdir_p SourceDir
  end

  def update!
    html_git.pull
    text_git.pull
    true
  end

  def download!
    Downloader.new(html_data_dir).download!
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
