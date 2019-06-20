set -g fish_prompt_pwd_dir_length 0
set -U FZF_TMUX 1

set -x EDITOR nvim
set -x VISUAL nvim

set PATH $HOME/dotfiles/bin $HOME/.anyenv/bin $GOPATH/bin ./node_modules/.bin $PATH 
set AWS_SDK_LOAD_CONFIG true

set GO111MODULE on

source (anyenv init - | psub)
eval (direnv hook fish)
eval (hub alias -s)
source '/Users/tomoya/google-cloud-sdk/path.fish.inc'

set PATH $GOROOT/bin $GOPATH/bin $PATH

function history-merge --on-event fish_preexec
  history save
  history merge
end

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
    printf "(%s%s %s%s%s%s)" (set_color --bold black) (git_branch_name) (set_color white) (string sub -l 7 (git rev-parse HEAD 2> /dev/null)) (git_action_prompt) (set_color normal)
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
    printf "(⎈ %s/%s)" (kubectl config current-context 2>/dev/null) (string length -q $namespace && echo $namespace || echo 'default')
  else
    printf ""
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


  echo
  echo (prompt_pwd) (git_prompt) (terraform_prompt) (kubernetes_prompt)
  echo (set_color $character_color)(echo $prompt_character)(set_color normal)' '
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tomoya/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/Users/tomoya/google-cloud-sdk/path.fish.inc'; else; . '/Users/tomoya/google-cloud-sdk/path.fish.inc'; end; end

test -f "$HOME/.config/fish/config.local.fish"; and source $HOME/.config/fish/config.local.fish
