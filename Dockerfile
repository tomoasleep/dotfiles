FROM ubuntu:latest
LABEL maintainer "Tomoya Chiba <tomo.asleep@gmail.com>"

ARG UID=1000
RUN useradd -u ${UID} --groups sudo editor

USER editor

COPY . /home/editor/dotfiles
RUN cd /home/editor/dotfiles && DOTFILES_NO_CLONE=t ./script/setup.sh
