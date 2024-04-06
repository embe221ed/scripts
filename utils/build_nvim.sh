#!/bin/sh

set -e

make distclean \
  && make clean \
  && rm -rf build out \
  && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/opt/neovim/out" \
  && make install
