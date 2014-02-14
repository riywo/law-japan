require "law/japan"

require "logger"

class Law::Japan::EGov
  HomeDir = File.join(Law::Japan::SourceDir, "e_gov")

  RepoDir = File.join(HomeDir, "repo")
  RepoURL = "https://github.com/riywo/law-japan-e_gov-text.git"

  def initialize(repo_dir: nil, repo_url: nil, logger: nil)
    repo_dir ||= self.class::RepoDir
    repo_url ||= self.class::RepoURL
    @logger = logger || Logger.new(STDOUT)

    @logger.info "Open or clone git repo(#{repo_dir}, #{repo_url}) and pull the latest data"
    @git = Git.open_or_clone(repo_dir, repo_url, log: @logger)
    pull
  end

  def pull
    @git.pull
  end

  def data_dir
    File.join(@git.dir.path, "data")
  end
end
