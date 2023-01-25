set -g fish_prompt_pwd_dir_length 0
set -g fish_prompt_pwd_full_dirs 3
set -U FZF_TMUX 1

set -x EDITOR nvim
set -x VISUAL nvim

if test -f /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
  set -x CPATH $CPATH (brew --prefix)/include
  set -x LIBRARY_PATH $LIBRARY_PATH (brew --prefix)/lib
end

# Wasmer
set -gx WASMER_DIR /Users/tomoya/.wasmer
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

set -gx WASMTIME_HOME "$HOME/.wasmtime"
fish_add_path $WASMTIME_HOME/bin

# set -x GOPATH $HOME/.go
fish_add_path -p /home/linuxbrew/.linuxbrew/bin
# https://github.com/WebAssembly/wasi-sdk/issues/172
fish_add_path -p /opt/homebrew/opt/llvm/bin
fish_add_path -p /snap/bin
fish_add_path -p $HOME/.cargo/bin
fish_add_path -p $HOME/.local/bin
fish_add_path -p $HOME/dotfiles/bin
fish_add_path -p $HOME/.anyenv/bin
if test -n "$GOPATH"
  fish_add_path -p $GOPATH/bin
  fish_add_path -p $GOROOT/bin
end
fish_add_path -p ./node_modules/.bin
fish_add_path -p $HOME/.krew/bin
fish_add_path -p /opt/homebrew/opt/openjdk/bin

which ghq > /dev/null; and fish_add_path (ghq root)/github.com/tomoasleep/private-utils/bin
test -f "$HOME/.asdf/asdf.fish"; and source $HOME/.asdf/asdf.fish

set -x AWS_SDK_LOAD_CONFIG true
set -gx CPPFLAGS "-I/opt/homebrew/opt/openjdk/include"

set GO111MODULE on

type -q anyenv; and source (anyenv init - | psub)
type -q direnv; and eval (direnv hook fish)
# type -q hub; and eval (hub alias -s)

if uname -a | grep -q 'microsoft'
  alias mcopy clip.exe
  alias mpaste "powershell.exe get-clipboard"
end

function git_is_repo -d "Check if directory is a repository"
  git rev-parse --is-inside-work-tree 2>/dev/null >/dev/null
end

function git_branch_name -d "Get current branch name"
  git_is_repo; and begin
    command git symbolic-ref --short HEAD
  end
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
    printf " (%s %s%s%s) " (fish_git_prompt "%s") (set_color black) (string sub -l 7 (git rev-parse HEAD 2> /dev/null)) (set_color normal)
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
  if test -n "$NO_KUBERNETES_PROMPT"
    return
  end

  if type -q kubectl && type -q jq && kubectl config view -o json | jq --exit-status .contexts > /dev/null
    set -l namespace (kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.namespace}")
    printf "(⎈ %s/%s)" (kubectl config current-context 2>/dev/null) (string length -q $namespace; and echo $namespace or echo 'default')
  else
    printf ""
  end
  if test -n "$KUBE_FORK_TARGET_ENV"
    printf "(🍴 %s)" (echo $KUBE_FORK_TARGET_ENV)
  end

end

function date_prompt
  echo (date "+[%Y/%m/%d %H:%M:%S]")
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
  echo (prompt_pwd) (date_prompt)(git_prompt) (kubernetes_prompt)
  echo (set_color $character_color)(echo $prompt_character)(set_color normal)' '
end

set -g __fish_git_prompt_show_informative_status true
set -g __fish_git_prompt_showcolorhints true
set -g __fish_git_prompt_color normal
set -g __fish_git_prompt_color_prefix normal
set -g __fish_git_prompt_color_suffix normal
set -g __fish_git_prompt_showupstream auto

set -U async_prompt_functions date_prompt kubernetes_prompt terraform_prompt

function date_prompt_loading_indicator -a last_prompt
  # echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
  # echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
  echo (set_color '#aaa')' … '(set_color normal)
end

function git_prompt_loading_indicator -a last_prompt
  # echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
  # echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
  echo (set_color '#aaa')' … '(set_color normal)
end

function kubernetes_prompt_loading_indicator -a last_prompt
  # echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
  # echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
  echo (set_color '#aaa')' … '(set_color normal)
end

function terraform_prompt_loading_indicator -a last_prompt
  # echo -n "$last_prompt" | sed -r 's/\x1B\[[0-9;]*[JKmsu]//g' | read -zl uncolored_last_prompt
  # echo -n (set_color brblack)"$uncolored_last_prompt"(set_color normal)
  echo (set_color '#aaa')' … '(set_color normal)
end

complete -f -c tmux-look -n "type -q ghq" -a "(ghq list | string match -r '(?<=github\.com/).+')"

## settings of done
set -U __done_min_cmd_duration 8000  # default: 5000 ms
set -U __done_exclude 'git (?!push|pull)'  # default: all git commands, except push and pull. accepts a regex.
set -U __done_notify_sound 1

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.fish.inc" ]; . "$HOME/google-cloud-sdk/path.fish.inc"; end
test -f "$HOME/.config/fish/config.local.fish"; and source $HOME/.config/fish/config.local.fish
