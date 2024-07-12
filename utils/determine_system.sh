#!/bin/sh

UNAME=$(uname)

case "${UNAME}" in
    Linux)
      exit 0
      ;;
    Darwin)
      exit 1
      ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      exit 2
      ;;
    *)
      exit -1
      ;;
esac
