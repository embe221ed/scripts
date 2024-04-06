FROM ubuntu:latest

RUN apt update && \
  apt install -y wget git

RUN mkdir -p /tmp/neovim
RUN wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz -P /tmp/neovim

WORKDIR /tmp/neovim

RUN tar xf nvim-linux64.tar.gz -C /root

COPY init.lua /root/.config/nvim/

WORKDIR /root
