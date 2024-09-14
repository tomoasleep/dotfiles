
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# ----------------------------------------

zinit ice as"plugin" hook-load"source ~/.config/zsh/config/zsh-autosuggestions.zsh"
zinit light zsh-users/zsh-autosuggestions

zinit ice as"plugin"
zinit light zsh-users/zsh-syntax-highlighting

zinit ice as"plugin"
zinit light unixorn/fzf-zsh-plugin

zinit light "olets/zsh-abbr"

zinit snippet PZT::modules/prompt

zinit ice from"local" pick"*.zsh"
zinit load ~/.config/zsh/local

# ----------------------------------------
