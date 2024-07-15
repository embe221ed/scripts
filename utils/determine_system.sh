#!/bin/sh

SCRIPT_NAME=$(basename "$0")
CURRENT_FILE=$(basename "${BASH_SOURCE[0]}")

UNAME=$(uname)

if [[ "${SCRIPT_NAME}" != "${CURRENT_FILE}" ]]; then
    echo "${UNAME}"
    exit 0
fi

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
