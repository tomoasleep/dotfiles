#!/bin/sh

set -ex

if which pip; then
  curl -kL https://bootstrap.pypa.io/get-pip.py | python - --user
fi

if python -c 'import pkgutil; exit(1 if pkgutil.find_loader("ansible") else 0)'; then
  pip install ansible --user
fi

DOTFILES_DIR=$HOME/.ghq/github.com/tomoasleep/dotfiles

# TODO: ensure git

if [ ! -d $DOTFILES_DIR ]; then
  mkdir -p $(dirname $DOTFILES_DIR)
  git clone https://github.com/tomoasleep/dotfiles.git $DOTFILES_DIR
fi

cd $DOTFILES_DIR

ansible-playbook $DOTFILES_DIR/playbook/localhost.yml
