#!/usr/bin/env bash
# Build and run the dev container.
#
#   ./run_docker.sh build [--refresh] [extra docker args…]
#   ./run_docker.sh [run] [extra docker args…]
#   ./run_docker.sh live            # run with the host repos bind-mounted
#
# --refresh pins every clone to the current upstream HEAD, which both makes the
# build reproducible and busts Docker's layer cache (otherwise a rebuild silently
# reuses a weeks-old checkout of embe221ed/scripts). The clone layer sits below
# every toolchain, so a refresh is cheap — it does not rebuild rust/python/node.
set -euo pipefail

IMAGE="${IMAGE:-devcontainer}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_NAME="${CONTAINER_USER:-embe221ed}"
HOME_IN="/home/${USER_NAME}"

head_of() { git ls-remote "https://github.com/embe221ed/$1" HEAD | cut -f1; }

cmd_build() {
  local refs=()
  if [[ "${1:-}" == "--refresh" ]]; then
    shift
    echo "resolving upstream HEADs…" >&2
    refs=(
      --build-arg "SCRIPTS_REF=$(head_of scripts)"
      --build-arg "INTERDOT_REF=$(head_of interdotensional)"
      --build-arg "INTERDIMUX_REF=$(head_of interdimux)"
      --build-arg "TSMOVE_REF=$(head_of tree-sitter-move-sui)"
      --build-arg "SVM_REF=$(head_of svm)"
    )
  fi
  docker buildx build \
    -f "$DIR/devContainer.dockerfile" \
    -t "$IMAGE" \
    --build-arg "USER_UID=$(id -u)" \
    --build-arg "USER_GID=$(id -g)" \
    "${refs[@]}" \
    "$@" \
    "$DIR"
}

# TERM is passed through so the generated tmux conf's `default-terminal "$TERM"`
# matches the outer terminal; the ghostty terminfo is compiled into the image.
#
# devcontainer-state is a named volume for $HOME state that is worth keeping
# across `--rm` runs: shell history, the zoxide database, nvim's shada/undo.
cmd_run() {
  docker run --rm -it \
    -e TERM="${TERM:-xterm-256color}" \
    -e "COLORTERM=${COLORTERM:-truecolor}" \
    -v devcontainer-state:"${HOME_IN}/.local/state" \
    ${SSH_AUTH_SOCK:+-v "$SSH_AUTH_SOCK":/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent} \
    --mount type=bind,source="$PWD",target="${HOME_IN}/work" \
    -w "${HOME_IN}/work" \
    "$@" \
    "$IMAGE"
}

# Shadow the image's clones with the live host checkouts. interdotensional's
# output/ is gitignored, so without this the container regenerates its own copy
# and `interdot toggle` on the two sides drifts apart.
#
# NOTE the anonymous volume over interdotensional/.venv: `uv run --directory`
# would otherwise rebuild the *host's* virtualenv in place, against a different
# interpreter, and leave it broken for the host.
#
# SECURITY: this mounts your real dotfiles read-write and forwards your ssh
# agent into a container that has NOPASSWD sudo. Anything running in here can
# rewrite /opt/scripts/configs/zsh/zshrc, which your host shell then sources.
# Use plain `run` — not `live` — when the working directory holds code you do
# not trust.
cmd_live() {
  cmd_run \
    --mount type=bind,source=/opt/scripts,target=/opt/scripts \
    --mount type=bind,source=/opt/tools/interdotensional,target=/opt/tools/interdotensional \
    --mount type=bind,source=/opt/tools/interdimux,target=/opt/tools/interdimux \
    --mount type=volume,target=/opt/tools/interdotensional/.venv \
    "$@"
}

case "${1:-run}" in
  build) shift; cmd_build "$@" ;;
  live)  shift; cmd_live "$@" ;;
  run)   shift; cmd_run "$@" ;;
  *)     cmd_run "$@" ;;
esac
