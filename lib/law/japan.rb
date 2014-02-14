require "law/japan/version"

module Law
  module Japan
    SourceDir = File.join(Dir.home, ".law-japan")
  end
end

require "git"

module Git
  def self.open_or_clone(dir, url, options = {})
    Git.open(dir, options)
  rescue
    name = File.basename(dir)
    path = File.dirname(dir)
    FileUtils.mkdir_p(path)
    Git.clone(url, name, options.merge(path: path))
  end
end

require "law/japan/e_gov"
