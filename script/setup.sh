#!/bin/bash

set -eux

ROOT_DIR=$(cd $(dirname $0)/.. && pwd)
cd $ROOT_DIR

if [ -z "${DOTFILES_NO_CLONE:-""}" ]; then
  DOTFILES_DIR=$HOME/.ghq/github.com/tomoasleep/dotfiles
  if [ ! -d $DOTFILES_DIR ]; then
    mkdir -p $(dirname $DOTFILES_DIR)
    git clone https://github.com/tomoasleep/dotfiles.git $DOTFILES_DIR
  fi

  cd $DOTFILES_DIR
fi

cd mitamae && $ROOT_DIR/bin/mitamae local recipe.rb

# Check if ansible is executable
# ansible --version
# ansible-playbook $DOTFILES_DIR/playbook/setup.yml --ask-become-pass
