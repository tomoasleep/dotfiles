require "minitest/autorun"

module CmdUtils
  def command(cmdline)
    require 'open3'

    warn "# $ #{cmdline}"
    pid = spawn(cmdline)
    _, status = Process.wait2(pid)
    unless status.success?
      fail "Command failed: #{cmdline}"
    end
  end
end

describe "devcontainer" do
  include CmdUtils

  it "can create devcontainer" do
    command(
      "docker run --entrypoint=bash --rm -it -u vscode -e REMOTE_CONTAINERS=true --mount type=bind,src=$(pwd),dst=/home/vscode/dotfiles mcr.microsoft.com/devcontainers/base:bullseye /home/vscode/dotfiles/setup"
    )
  end
end
