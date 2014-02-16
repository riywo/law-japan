require "law/japan"
require "law/japan/git"

require "logger"

class Law::Japan::EGov
  include Law::Japan::Git

  HomeDir = File.join(Law::Japan::HomeDir, "e_gov")
  RepoDir = File.join(HomeDir, "repo")
  RepoURL = "https://github.com/riywo/law-japan-e_gov-text.git"

  def initialize(repo_dir: nil, repo_url: nil, logger: nil)
    @repo_dir = repo_dir || RepoDir
    @repo_url = repo_url || RepoURL
    @logger   = logger   || Logger.new(STDOUT)
  end

  class CLI < Law::Japan::EGov
    include Law::Japan::Git::CLI
  end
end
