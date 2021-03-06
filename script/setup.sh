#!/bin/sh

set -eux

ansible --version > /dev/null

DOTFILES_DIR=$HOME/.ghq/github.com/tomoasleep/dotfiles

# TODO: ensure git

if [ ! -d $DOTFILES_DIR ]; then
  mkdir -p $(dirname $DOTFILES_DIR)
  git clone https://github.com/tomoasleep/dotfiles.git $DOTFILES_DIR
fi

cd $DOTFILES_DIR

ansible-playbook $DOTFILES_DIR/playbook/setup.yml --ask-become-pass
