#!/bin/sh

TEMP_DIR=$(mktemp -d)
CURR=$(pwd)
echo "[*] created temporary directory: ${TEMP_DIR}"

cd ${TEMP_DIR} && mkdir solve && cd solve

forge init
cd ${TEMP_DIR} \
  && mv solve ${CURR}/ \
  && cd ${CURR} \
  && rmdir ${TEMP_DIR}
