#!/usr/bin/env bash
docker run --rm -it \
  --cap-add=SYS_PTRACE \
  --security-opt seccomp=unconfined \
  --mount type=bind,source="$PWD",target=/home/pwntools/work \
  -w /home/pwntools/work \
  ctf-pwn
