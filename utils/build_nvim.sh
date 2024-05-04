#!/bin/sh

set -e

if [ "$(basename $(pwd))" != "neovim" ]; then
  echo "[!] probably wrong directory, exiting just in case"
  exit 1
fi

echo "[*] pulling latest changes"
git pull

echo "[*] building newest version and installing it"
make distclean \
  && make clean \
  && rm -rf build out \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/opt/neovim/out" \
  && make install
