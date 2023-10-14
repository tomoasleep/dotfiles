file "Ensure fish is a shell candidate" do
  action :edit
  path "/etc/shells"
  user "root"
  only_if "test -f /opt/homebrew/bin/fish"

  block do |content|
    if !content.include?("/opt/homebrew/bin/fish")
      content << "/opt/homebrew/bin/fish\n"
    end
  end
end

file "Ensure zsh is a shell candidate" do
  action :edit
  path "/etc/shells"
  user "root"
  only_if "test -f /opt/homebrew/bin/zsh"

  block do |content|
    if !content.include?("/opt/homebrew/bin/zsh")
      content << "/opt/homebrew/bin/zsh\n"
    end
  end
end
