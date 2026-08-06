#!/usr/bin/env bash
# Build and run the dev container.
#
#   ./run_docker.sh build [--refresh] [extra docker args…]
#   ./run_docker.sh [run] [extra docker args…]
#   ./run_docker.sh live            # run with the host repos bind-mounted
#
# This script is a convenience, never a requirement. The image is self-contained:
#
#   docker run --rm -it dev-container:latest
#
# works from anywhere and gives you the full environment — prompt, theme, tmux,
# nvim, LSPs. What this script adds on top is only the host-coupled parts, none
# of which the image can set for itself: your real $TERM, your ssh agent, the
# current directory mounted at ~/work, and a named volume so shell history and
# nvim state outlive --rm.
#
# --refresh pins every clone to the current upstream HEAD, which both makes the
# build reproducible and busts Docker's layer cache (otherwise a rebuild silently
# reuses a weeks-old checkout of embe221ed/scripts). The clone layer sits below
# every toolchain, so a refresh is cheap — it does not rebuild rust/python/node.
set -euo pipefail

IMAGE="${IMAGE:-dev-container}"
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_NAME="${CONTAINER_USER:-embe221ed}"
HOME_IN="/home/${USER_NAME}"

# This script is `set -euo pipefail` and the refs below are built inside an array
# assignment, so a failing command substitution kills the whole run before docker
# is ever invoked — with no clue as to which repo failed. Say which.
head_of() {
  git ls-remote "https://github.com/embe221ed/$1" HEAD | cut -f1 |
    grep -E '^[0-9a-f]{40}$' || { echo "cannot resolve HEAD of embe221ed/$1" >&2; exit 1; }
}

cmd_build() {
  local refs=()
  if [[ "${1:-}" == "--refresh" ]]; then
    shift
    echo "resolving upstream HEADs…" >&2
    refs=(
      --build-arg "SCRIPTS_REF=$(head_of scripts)"
      --build-arg "DOTFILES_REF=$(head_of dotfiles)"
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
# matches the outer terminal; the ghostty terminfo is compiled into the image and
# ncurses-term covers alacritty/wezterm/foot/rio/contour. It is *checked* first
# because tmux exits with "missing or unsuitable terminal" on an entry the
# container does not have (xterm-kitty is the common one), which would be a
# strictly worse session than the image's own xterm-256color default.
#
# COLORTERM is deliberately not forwarded: the image sets COLORTERM=truecolor
# itself, because fast-syntax-highlighting falls back to zsh/nearcolor without it
# and quantises the whole 24-bit theme to 256 colours.
#
# dev-container-state is a named volume for $HOME state that is worth keeping
# across `--rm` runs: shell history, the zoxide database, nvim's shada/undo.
# ~/.zshrc.local in the image points HISTFILE and $_ZO_DATA_DIR at it.
cmd_run() {
  local term="${TERM:-xterm-256color}"
  if [[ "$term" != xterm-256color ]] \
     && ! docker run --rm "$IMAGE" infocmp "$term" >/dev/null 2>&1; then
    echo "note: no terminfo for '$term' in $IMAGE — using xterm-256color" >&2
    term=xterm-256color
  fi
  docker run --rm -it \
    -e TERM="$term" \
    -v dev-container-state:"${HOME_IN}/.local/state" \
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
# rewrite /opt/dotfiles/zsh/zshrc, which your host shell then sources.
# Use plain `run` — not `live` — when the working directory holds code you do
# not trust.
#
# The host-side sources are overridable so a machine that does not keep its
# checkouts under /opt is not excluded. The container-side targets stay
# hardcoded: the image's own clones live at those paths and its ~/.zshrc points
# into /opt/dotfiles.
#
# CAVEAT on a non-/opt host: the dotfiles repo's intra-repo generated links
# (nvim/lua/*.generated.lua) are ABSOLUTE into that host's interdotensional
# checkout, so under `live` they dangle inside the container. nvim still starts —
# the committed shims fall back — but unthemed. Use plain `run`, or re-run
# `interdot link` inside the container.
cmd_live() {
  cmd_run \
    --mount type=bind,source="${DOTFILES:-/opt/dotfiles}",target=/opt/dotfiles \
    --mount type=bind,source="${SCRIPTS:-/opt/scripts}",target=/opt/scripts \
    --mount type=bind,source="${INTERDOT:-/opt/tools/interdotensional}",target=/opt/tools/interdotensional \
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
