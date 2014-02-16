require "law/japan"

require "thor"

class Law::Japan::CLI < Thor
  desc "install", "Install git repo"
  def install
    e_gov = Law::Japan::EGov::CLI.new
    e_gov.install
  end

  desc "update", "Pull the latest data"
  def update
    e_gov = Law::Japan::EGov::CLI.new
    e_gov.pull
  end
end
