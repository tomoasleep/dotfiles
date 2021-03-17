set -g fish_prompt_pwd_dir_length 0
set -U FZF_TMUX 1

set -x EDITOR nvim
set -x VISUAL nvim

set -x GOPATH $HOME/.go
set PATH /home/linuxbrew/.linuxbrew/bin $PATH 
set PATH /snap/bin $PATH 
set PATH $HOME/.cargo/bin $PATH 
set PATH $HOME/dotfiles/bin $HOME/.anyenv/bin $GOPATH/bin ./node_modules/.bin $PATH 
set PATH $PATH $HOME/.krew/bin
set -x AWS_SDK_LOAD_CONFIG true

set GO111MODULE on

type -q anyenv; and source (anyenv init - | psub)
type -q direnv; and eval (direnv hook fish)
type -q hub; and eval (hub alias -s)

set PATH $GOROOT/bin $GOPATH/bin $PATH

function git_action_prompt
  if git_is_repo
		set -l git_action_value (git_action_status)

		if test $status -eq 0
			printf " +%s" $git_action_value
		end
	end
end

function git_prompt
  if git_is_repo
    printf "(%s%s %s%s%s%s)" (set_color yellow) (git_branch_name) (set_color white) (string sub -l 7 (git rev-parse HEAD 2> /dev/null)) (git_action_prompt) (set_color normal)
  else
    printf ""
  end
end

function terraform_prompt
  if terraform_is_repo
    printf "(Workspace: %s%s%s)" (set_color --bold black) (terraform_workspace 2> /dev/null) (set_color normal)
  else
    printf ""
  end
end

function kubernetes_prompt
  if type -q kubectl
    set -l namespace (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")
    printf "(⎈ %s/%s)" (kubectl config current-context 2>/dev/null) (string length -q $namespace; and echo $namespace or echo 'default')
  else
    printf ""
  end
  if test -n "$KUBE_FORK_TARGET_ENV"
    printf "(🍴 %s)" (echo $KUBE_FORK_TARGET_ENV)
  end

end

function fish_prompt
  if test $status -eq 0
    set prompt_character "(ρ _-)ノ"
    set character_color "green"
  else
    set prompt_character "_(:3」[＿]"
    set character_color "red"
  end

  if test -n "$REC_MODE"
    echo '$ '
    return
  end

  echo
  echo (prompt_pwd) (date "+[%Y/%m/%d %H:%M:%S]") (git_prompt) (kubernetes_prompt)
  echo (set_color $character_color)(echo $prompt_character)(set_color normal)' '
end

complete -f -c tmux-look -n "type -q ghq" -a "(ghq list | string match -r '(?<=github\.com/).+')"

## settings of done
set -U __done_min_cmd_duration 8000  # default: 5000 ms
set -U __done_exclude 'git (?!push|pull)'  # default: all git commands, except push and pull. accepts a regex.
set -U __done_notify_sound 1

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.fish.inc" ]; . "$HOME/google-cloud-sdk/path.fish.inc"; end

test -f "$HOME/.config/fish/config.local.fish"; and source $HOME/.config/fish/config.local.fish

