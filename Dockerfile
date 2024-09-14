FROM ubuntu:focal
LABEL maintainer "Tomoya Chiba <tomo.asleep@gmail.com>"

ARG UID=1000
RUN useradd -u ${UID} --groups sudo editor

RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER editor

COPY --chown=editor:editor . /home/editor/dotfiles
RUN cd /home/editor/dotfiles && DOTFILES_NO_CLONE=t ./script/setup.sh

WORKDIR /home/editor
CMD /bin/bash
