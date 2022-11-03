#!/bin/bash

set -eux

HOMEBREW_DIR=$HOME/brew
if [ ! -d $HOMEBREW_DIR ]; then
  git clone https://github.com/Homebrew/brew $HOMEBREW_DIR
fi

RUBY_BUILD_DIR=$HOME/.ruby-build
if [ ! -d $RUBY_BUILD_DIR ]; then
  git clone https://github.com/rbenv/ruby-build.git $RUBY_BUILD_DIR
fi

HOMEBREW_VENDOR_DIR=${HOMEBREW_DIR}/Library/Homebrew/vendor
HOMEBREW_PORTABLE_RUBY_DIR=${HOMEBREW_VENDOR_DIR}/portable-ruby
if [ ! -d $HOMEBREW_PORTABLE_RUBY_DIR ]; then
  mkdir $HOMEBREW_PORTABLE_RUBY_DIR
fi

HOMEBREW_LATEST_VERSION="$(cat ${HOMEBREW_VENDOR_DIR}/portable-ruby-version)"
HOMEBREW_LATEST_RUBY_DIR=${HOMEBREW_PORTABLE_RUBY_DIR}/${HOMEBREW_LATEST_VERSION}
if [ ! -d $HOMEBREW_LATEST_RUBY_DIR ]; then
  $RUBY_BUILD_DIR/bin/ruby-build ${HOMEBREW_LATEST_VERSION%%_*} $HOMEBREW_LATEST_RUBY_DIR
fi

HOMEBREW_CURRENT_VERSION="$(readlink "${HOMEBREW_PORTABLE_RUBY_DIR}/current" || echo "")"
if [[ $HOMEBREW_CURRENT_VERSION != $HOMEBREW_LATEST_VERSION ]]; then
  (cd $HOMEBREW_PORTABLE_RUBY_DIR && ln -s $HOMEBREW_LATEST_VERSION current)
fi
