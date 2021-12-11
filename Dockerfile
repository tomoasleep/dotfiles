FROM ubuntu:latest
LABEL maintainer "Tomoya Chiba <tomo.asleep@gmail.com>"

COPY . /root/dotfiles
RUN cd /root/dotfiles && ./script/setup.sh
