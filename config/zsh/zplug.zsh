if [[ -d ~/.zplug ]]; then
    export ZPLUG_HOME=~/.zplug
    source $ZPLUG_HOME/init.zsh
else
    export ZPLUG_HOME=$(brew --prefix)/opt/zplug
    source $ZPLUG_HOME/init.zsh
fi


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
