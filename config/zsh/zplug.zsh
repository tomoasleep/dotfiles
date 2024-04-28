
export ZPLUG_HOME=~/.zplug

if [[ ! -d $ZPLUG_HOME ]]; then
  printf "Install zplug? [y/N]"
  if read -q; then
    echo
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    sleep 1 # Wait init.zsh is prepared
  fi
fi

source $ZPLUG_HOME/init.zsh

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# ----------------------------------------

zplug "zsh-users/zsh-autosuggestions", as:plugin, hook-load:"source ~/.config/zsh/config/zsh-autosuggestions.zsh"
zplug "zsh-users/zsh-syntax-highlighting", as:plugin
zplug "unixorn/fzf-zsh-plugin", as:plugin
zplug "olets/zsh-abbr"
zplug "modules/prompt", from:prezto

zplug "~/.config/zsh/local", from:local, use:"*.zsh"

# ----------------------------------------

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load # --verbose
