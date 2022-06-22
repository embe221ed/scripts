#!/bin/bash

sudo rm initramfs.cpio.gz
set -e  # Crash on failures

sudo gcc -Wall -Wpedantic -Wextra -static -Os exp.c -o exp
sudo cp exp ./unpacked/exp

sudo ./pack.sh

QEMU_COMMAND='whoami'
terminator --new-tab -e "$QEMU_COMMAND"
