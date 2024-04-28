source ~/.config/zsh/init.zsh

# pnpm
export PNPM_HOME="/Users/tomoya/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end