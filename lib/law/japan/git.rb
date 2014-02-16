require "law/japan"

require "git"

module Law::Japan::Git
  def data_dir
    @data_dir ||= File.join(git.dir.path, "data")
  end

  private

  def git
    unless @git
      begin
        @git ||= ::Git.open(repo_dir, log: logger)
      rescue ArgumentError
        raise "#{repo_dir} has not been ready yet"
      end

      origin_url = @git.remote("origin").url
      if origin_url != repo_url
        raise "origin url(#{origin_url}) must be #{repo_url}"
      end
    end
    @git
  end

  def repo_dir
    @repo_dir
  end

  def repo_url
    @repo_url
  end

  def logger
    @logger
  end

  module CLI
    def install
      FileUtils.rm_rf(repo_dir)

      name = File.basename(repo_dir)
      path = File.dirname(repo_dir)
      FileUtils.mkdir_p(path)
      ::Git.clone(repo_url, name, path: path)
    end

    def pull
      git.pull
    end
  end
end
