
if test -f /opt/homebrew/bin/brew; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export CPATH=$CPATH:(brew --prefix)/include
  export LIBRARY_PATH=$LIBRARY_PATH:(brew --prefix)/lib
fi

if test -f /home/linuxbrew/.linuxbrew/bin/brew; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  export CPATH=$CPATH:(brew --prefix)/include
  export LIBRARY_PATH=$LIBRARY_PATH:(brew --prefix)/lib
fi
