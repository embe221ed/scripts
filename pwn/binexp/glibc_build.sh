#!/usr/bin/env bash

if [[ $# != 1 ]];
then
    echo 'Usage: ./glibc_install.sh VERSION'
    exit
fi
VER=$1
cd /opt/glibc
git checkout glibc-$VER || (echo 'Incorrect VERSION' && exit)
mkdir -p build
cd build
export glibc_install="$(pwd)/install"
../configure --prefix "$glibc_install" --disable-werror
make -j `nproc`
make install -j `nproc`
