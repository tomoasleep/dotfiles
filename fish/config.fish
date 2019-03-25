if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

set -g fish_prompt_pwd_dir_length 0
set -U FZF_TMUX 1

set -x EDITOR nvim
set -x VISUAL nvim

set -x GOPATH $HOME/.go
set PATH $HOME/dotfiles/bin $HOME/.anyenv/bin $GOPATH/bin ./node_modules/.bin $PATH 

source (anyenv init - | psub)
eval (direnv hook fish)
eval (hub alias -s)
source '/Users/tomoya/google-cloud-sdk/path.fish.inc'

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

function fish_prompt
  if test $status -eq 0
    set prompt_character "(ρ _-)ノ"
    set character_color "green"
  else
    set prompt_character "_(:3」[＿]"
    set character_color "red"
  end


  echo
  echo (prompt_pwd) (git_prompt) (terraform_prompt)
  echo (set_color $character_color)(echo $prompt_character)(set_color normal)' '
end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/tomoya/google-cloud-sdk/path.fish.inc' ]; if type source > /dev/null; source '/Users/tomoya/google-cloud-sdk/path.fish.inc'; else; . '/Users/tomoya/google-cloud-sdk/path.fish.inc'; end; end

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/tomoya/.anyenv/envs/nodenv/versions/8.9.4/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish ]; and . /Users/tomoya/.anyenv/envs/nodenv/versions/8.9.4/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.fish
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/tomoya/.anyenv/envs/nodenv/versions/8.9.4/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish ]; and . /Users/tomoya/.anyenv/envs/nodenv/versions/8.9.4/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.fish
