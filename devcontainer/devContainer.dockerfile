# syntax=docker/dockerfile:1.7
#
# devContainer — replicates the host dev environment (zsh + oh-my-zsh + the
# interdotensional theme pipeline, tmux + interdimux, neovim, and the toolchains
# behind the LSP servers the nvim config configures).
#
# BUILD (BuildKit/buildx required — TARGETARCH and heredocs):
#   cd /opt/scripts/devcontainer
#   ./run_docker.sh build             # or:
#   docker buildx build -f devContainer.dockerfile -t dev-container \
#     --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) .
#
# NOTE: the build clones embe221ed/scripts from GitHub, so any change to
# configs/zsh/* or configs/nvim/* must be COMMITTED AND PUSHED before it shows up
# in the image. Use ./run_docker.sh --refresh to pin the clones to current HEADs,
# or bind-mount /opt/scripts at run time to iterate without rebuilding.

FROM ubuntu:24.04

# --- 0. Base environment ------------------------------------------------------
# DEBIAN_FRONTEND is an ARG, not an ENV: as an ENV it leaks into the running
# container and silently skips debconf prompts for interactive `sudo apt install`.
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# A UTF-8 locale is load-bearing, not cosmetic: interdimux counts column widths in
# cells and misaligns under LC_ALL=C, the generated tmux status line and zsh theme
# are full of multibyte glyphs, and zsh's ZLE mis-measures the prompt. glibc 2.39
# on noble has C.UTF-8 built in, so no `locales` package is needed. Set before apt
# so build steps inherit it too.
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# --- 1. System packages -------------------------------------------------------
# ca-certificates/openssh-client: HTTPS + `git clone git@…` for private repos
# less/man-db/procps/file: git's pager and basic shell ergonomics
# build-essential/pkg-config/autoconf/patch: tmux build, python-build, ruby-build,
#   and the C compiler nvim-treesitter shells out to at runtime
# libevent-dev/libncurses-dev/bison: tmux — its configure checks for yacc even
#   though the release tarball ships a pre-generated cmd-parse.c
# libssl…uuid-dev: CPython build deps (pyenv)
# libyaml-dev/libgmp-dev: Ruby build deps (rbenv)
# ncurses-bin: `tic`, for the ghostty terminfo below; ncurses-term: extra TERMs
# at: interdimux's Schedule/Jobs dashboard entries
#
# The first three commands restore documentation: ubuntu:24.04 ships an excludes
# file that strips man pages from every package it installs, and diverts
# /usr/bin/man to a stub that just tells you to run `unminimize`. Undoing both is
# far cheaper than `unminimize` and gives working man pages for everything
# installed below — which matters because ~/.zshenv pipes `man` through bat.
# (Pages for packages already in the base image, e.g. coreutils, stay stripped.)
RUN rm -f /etc/dpkg/dpkg.cfg.d/excludes /usr/bin/man \
    && dpkg-divert --quiet --remove --rename /usr/bin/man \
    && apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    wget \
    git \
    openssh-client \
    gnupg \
    sudo \
    zsh \
    less \
    man-db \
    manpages \
    procps \
    file \
    unzip \
    xz-utils \
    ncurses-bin \
    ncurses-term \
    build-essential \
    pkg-config \
    autoconf \
    patch \
    bison \
    libevent-dev \
    libncurses-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libffi-dev \
    liblzma-dev \
    libyaml-dev \
    libgmp-dev \
    libgdbm-dev \
    libgdbm-compat-dev \
    uuid-dev \
    ripgrep \
    fd-find \
    jq \
    direnv \
    bat \
    zoxide \
    at \
    clangd-18 \
    && ln -sf /usr/bin/batcat /usr/local/bin/bat \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && ln -sf /usr/bin/clangd-18 /usr/local/bin/clangd \
    && rm -rf /var/lib/apt/lists/*

# --- 2. Neovim ----------------------------------------------------------------
# Pinned and arch-aware. The nvim config uses vim.lsp.config/vim.treesitter.start,
# so >= 0.11 is a hard floor. Every download below uses `curl -f`: without it a
# 404 body is written to the tarball and `tar` fails with a misleading error.
ARG TARGETARCH
ARG NVIM_VERSION=v0.12.4
RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) A=x86_64 ;; \
      arm64) A=arm64 ;; \
      *) echo "unsupported TARGETARCH: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/nvim.tar.gz \
      "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-${A}.tar.gz"; \
    tar -C /opt -xzf /tmp/nvim.tar.gz; \
    ln -sf "/opt/nvim-linux-${A}/bin/nvim" /usr/local/bin/nvim; \
    rm /tmp/nvim.tar.gz; \
    nvim --version | head -1

# --- 3. Tmux (from source) ----------------------------------------------------
# Must be built: noble ships 3.4, interdimux requires >= 3.6, and the generated
# ~/.tmux.conf uses `new-pane`, which is 3.7+. The version is pinned rather than
# resolved through api.github.com — that API rate-limits at 60 req/h/IP and a
# throttled response used to yield a `tmux-null.tar.gz` mid-build failure.
ARG TMUX_VERSION=3.7b
RUN set -eux; \
    curl -fsSL -o /tmp/tmux.tar.gz \
      "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"; \
    tar -xzf /tmp/tmux.tar.gz -C /tmp; \
    cd "/tmp/tmux-${TMUX_VERSION}"; \
    ./configure --prefix=/usr/local; \
    make -j"$(nproc)"; \
    make install; \
    cd /; rm -rf /tmp/tmux.tar.gz "/tmp/tmux-${TMUX_VERSION}"; \
    tmux -V

# --- 4. fzf -------------------------------------------------------------------
# Not from apt: noble ships 0.44, interdimux needs >= 0.74 (it degrades silently
# below that) and `fzf --zsh` needs >= 0.48. fzf-tmux is not in the release
# archive but tmux-fuzzback shells out to it by name.
ARG FZF_VERSION=0.74.2
RUN set -eux; \
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${TARGETARCH}.tar.gz" \
      | tar -xz -C /usr/local/bin fzf; \
    curl -fsSL -o /usr/local/bin/fzf-tmux \
      "https://raw.githubusercontent.com/junegunn/fzf/v${FZF_VERSION}/bin/fzf-tmux"; \
    chmod 755 /usr/local/bin/fzf-tmux; \
    fzf --version

# --- 5. tree-sitter CLI -------------------------------------------------------
# nvim-treesitter's `main` branch shells out to `tree-sitter generate|build` for
# every parser and enforces a minimum version; without it there is no syntax
# highlighting at all. apt's 0.20.8 is below the floor.
ARG TS_CLI_VERSION=v0.26.11
RUN set -eux; \
    case "$TARGETARCH" in amd64) A=x64 ;; arm64) A=arm64 ;; esac; \
    curl -fsSL -o /tmp/ts.gz \
      "https://github.com/tree-sitter/tree-sitter/releases/download/${TS_CLI_VERSION}/tree-sitter-linux-${A}.gz"; \
    gunzip -c /tmp/ts.gz > /usr/local/bin/tree-sitter; \
    chmod 755 /usr/local/bin/tree-sitter; rm /tmp/ts.gz; \
    tree-sitter --version

# --- 6. lua-language-server ---------------------------------------------------
# lsp.lua configures lua_ls; there is no apt package. Needed to edit this very
# nvim config from inside the container.
ARG LUALS_VERSION=3.18.2
RUN set -eux; \
    case "$TARGETARCH" in amd64) A=x64 ;; arm64) A=arm64 ;; esac; \
    mkdir -p /opt/lua-language-server; \
    curl -fsSL "https://github.com/LuaLS/lua-language-server/releases/download/${LUALS_VERSION}/lua-language-server-${LUALS_VERSION}-linux-${A}.tar.gz" \
      | tar -xz -C /opt/lua-language-server; \
    ln -sf /opt/lua-language-server/bin/lua-language-server /usr/local/bin/lua-language-server; \
    lua-language-server --version

# --- 7. Ghostty terminfo ------------------------------------------------------
# Lets TERM=xterm-ghostty be recognised when run_docker.sh forwards it. TERM's
# own default is set with the rest of the run-time env at step 10, so a bare
# `docker run` needs no -e flag. Whatever TERM ends up holding must have a
# terminfo entry *inside* the container: the generated tmux conf does
# `set -g default-terminal "$TERM"`, and tmux refuses to start on an unknown
# one — which is why run_docker.sh falls back instead of forwarding blindly.
# ncurses-term covers alacritty/wezterm/foot/rio/contour; xterm-kitty is not
# in it.
COPY ./ghostty.terminfo /tmp/ghostty.terminfo
RUN tic -x /tmp/ghostty.terminfo && rm /tmp/ghostty.terminfo

# --- 8. User ------------------------------------------------------------------
# Build with --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) so that
# bind-mounted work directories stay writable from both sides.
ARG USERNAME=embe221ed
ARG USER_UID=1337
ARG USER_GID=$USER_UID

# ubuntu:24.04 ships a stock `ubuntu` user at uid/gid 1000; drop it if it would
# collide with the requested ids.
RUN set -eux; \
    if getent passwd "$USER_UID" >/dev/null; then userdel -r "$(getent passwd "$USER_UID" | cut -d: -f1)" || true; fi; \
    if getent group "$USER_GID" >/dev/null; then groupdel "$(getent group "$USER_GID" | cut -d: -f1)" || true; fi; \
    groupadd --gid "$USER_GID" "$USERNAME"; \
    useradd --uid "$USER_UID" --gid "$USER_GID" -m "$USERNAME" -s /usr/bin/zsh; \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/"$USERNAME"; \
    chmod 0440 /etc/sudoers.d/"$USERNAME"

# --- 9. Repository directories ------------------------------------------------
# Only the (user-owned, empty) directories here. The clones themselves happen
# near the end of the build: they are the layer that changes most often, and
# anything above them gets rebuilt when they are invalidated — putting them here
# would mean `--refresh` (or any push to embe221ed/scripts) re-runs CPython,
# rustup, node, ruby and the nvim warm-up for a one-line dotfile change.
RUN install -d -o "$USERNAME" -g "$USERNAME" \
      /opt/scripts /opt/tools /opt/tools/interdotensional /opt/tools/interdimux \
      /opt/tree-sitter-parsers /opt/tree-sitter-parsers/tree-sitter-move-sui

# --- 10. User environment -----------------------------------------------------
USER $USERNAME
WORKDIR /home/$USERNAME
ENV HOME=/home/$USERNAME
ENV PYENV_ROOT="$HOME/.pyenv"
# This PATH is what `docker exec <c> <cmd>` and the RUN steps below see; the
# interactive shell rebuilds it from configs/zsh/{zshenv,zshrc}.
ENV PATH="$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.svm/bin:$HOME/.foundry/bin:$PYENV_ROOT/bin:$PYENV_ROOT/shims:/opt/scripts/utils:$PATH"
# DEV_CONTAINER is what the prompt badge keys off. It is an ENV, not something
# the wrapper script passes, so it is set for `docker run`, `docker exec`, every
# tmux pane, and any nested or re-exec'd shell.
ENV DEV_CONTAINER=1
# Only reaches non-interactive processes (`docker exec`, the RUN steps below).
# Every interactive shell gets its value from $ZSH_CUSTOM/interdot.zsh instead,
# which oh-my-zsh sources after this — the generated fragment is the source of
# truth, and under `run_docker.sh live` (host output/ bind-mounted) it can
# legitimately disagree with the value here.
ENV DISPLAY_MODE=Dark
# Defaults for a bare `docker run --rm -it dev-container` with no -e flags.
#
# COLORTERM is load-bearing, not cosmetic. fast-syntax-highlighting ends with
#     [[ ${COLORTERM-} == (24bit|truecolor) || ${terminfo[colors]} -eq 16777216 ]] \
#       || zmodload zsh/nearcolor
# and xterm-256color's terminfo reports 256, so without COLORTERM every 24-bit
# hex colour in the generated theme — the whole gruvbox palette and the ❮dev❯
# badge — gets silently rounded to the nearest xterm-256 colour. The host gets
# COLORTERM from its terminal; the container has to assert it.
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# --- 11. Oh My Zsh + custom plugins ------------------------------------------
# --keep-zshrc: ~/.zshrc is a symlink into the repo (step 22), not a generated file.
# Only these three plugins need cloning — git, virtualenv, vi-mode, direnv,
# colored-man-pages, extract, history-substring-search and nvm ship with omz.
RUN set -eux; \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc; \
    ZC="$HOME/.oh-my-zsh/custom/plugins"; \
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions              "$ZC/zsh-autosuggestions"; \
    git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZC/fast-syntax-highlighting"; \
    git clone --depth 1 https://github.com/Aloxaf/fzf-tab                             "$ZC/fzf-tab"

# --- 12. uv -------------------------------------------------------------------
RUN curl -fsSL https://astral.sh/uv/install.sh | sh && uv --version

# --- 13. Python (pyenv) -------------------------------------------------------
# A real interpreter, not just the version manager: the generated tmux conf points
# @fzf-links-python at $HOME/.pyenv/shims/python3, and pyenv creates shims only
# once a version exists.
ARG PYTHON_VERSION=3.13.14
RUN set -eux; \
    curl -fsSL https://pyenv.run | bash; \
    pyenv install "$PYTHON_VERSION"; \
    pyenv global "$PYTHON_VERSION"; \
    pyenv rehash; \
    test -x "$HOME/.pyenv/shims/python3"

# pyrefly is the Python LSP lsp.lua configures. uv installs it into ~/.local/bin,
# which is on PATH unconditionally.
RUN uv tool install pyrefly && pyrefly --version && uv cache clean

# --- 14. Rust -----------------------------------------------------------------
# `--profile minimal` alone ships no rust-analyzer, which rustaceanvim needs, and
# no rust-src, without which rust-analyzer cannot resolve std/core.
ARG RUST_TOOLCHAIN=stable
RUN curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs \
      | sh -s -- -y --profile minimal --default-toolchain "$RUST_TOOLCHAIN" \
        -c rust-analyzer -c rust-src -c clippy -c rustfmt \
    && rustc --version && rust-analyzer --version

# --- 15. Sui / Move (svm) -----------------------------------------------------
# move_analyzer is the LSP for the primary audit language. svm manages the `sui`
# and `move-analyzer` binaries. This is the single largest optional component —
# build with --build-arg WITH_SUI=0 to skip it (~400 MB).
# `svm install latest` resolves and activates in one step (there is no separate
# `svm use latest` — "latest" is not a version name, only an install selector),
# so the assertion below is what proves the LSP actually landed on PATH.
ARG WITH_SUI=1
ARG SVM_REF=HEAD
RUN set -eux; \
    if [ "$WITH_SUI" = "1" ]; then \
      . "$HOME/.cargo/env"; \
      if [ "$SVM_REF" = HEAD ]; then \
        cargo install --locked --git https://github.com/embe221ed/svm svm; \
      else \
        cargo install --locked --git https://github.com/embe221ed/svm --rev "$SVM_REF" svm; \
      fi; \
      svm install latest; \
      command -v move-analyzer; \
      rm -rf "$HOME/.svm/cache" "$HOME/.cargo/registry" "$HOME/.cargo/git"; \
    fi

# --- 16. Node (nvm) + npm language servers -----------------------------------
# Without a Node runtime, solidity_ls_nomicfoundation, bashls and ts_ls are all
# configured in lsp.lua but never start, and solhint fails the executable check
# silently.
ARG WITH_NODE=1
ARG NVM_VERSION=v0.40.6
# The ~/.local/bin symlinks are load-bearing, not convenience: the omz nvm plugin
# is lazy (zstyle ':omz:plugins:nvm' lazy yes), so ~/.nvm/versions/node/*/bin is
# absent from PATH until you actually run node/npm. Neovim spawns its LSP servers
# with the PATH it inherited, so without these, solidity/bash/ts servers are
# silently never found — and even a direct path to them fails, because their
# `#!/usr/bin/env node` shebang needs node on PATH too.
#
# PROFILE=/dev/null keeps the installer from appending its own block to a shell
# rc file (~/.zshrc becomes a symlink into the repo two steps down).
# NVM_DIR must be exported explicitly and `set -u` turned off around the source:
# nvm.sh cannot self-locate when sourced from dash (it resolved NVM_DIR to /bin)
# and it reads unset variables such as TMPDIR.
RUN set -eux; \
    if [ "$WITH_NODE" = "1" ]; then \
      curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | PROFILE=/dev/null bash; \
      export NVM_DIR="$HOME/.nvm"; \
      set +u; \
      . "$NVM_DIR/nvm.sh"; \
      nvm install --lts; \
      nvm alias default 'lts/*'; \
      npm install -g \
        @nomicfoundation/solidity-language-server \
        solhint \
        typescript \
        typescript-language-server \
        bash-language-server; \
      mkdir -p "$HOME/.local/bin"; \
      for b in node npm npx \
               nomicfoundation-solidity-language-server solhint \
               typescript-language-server bash-language-server; do \
        p="$(command -v "$b")"; ln -sf "$p" "$HOME/.local/bin/$b"; \
      done; \
      "$HOME/.local/bin/bash-language-server" --version; \
      rm -rf "$HOME/.npm/_cacache" "$NVM_DIR/.cache"; \
    fi

# --- 17. Foundry --------------------------------------------------------------
# lsp.lua uses foundry.toml/remappings.txt as the solidity root markers, so the
# LSP assumes a Foundry layout; forge/cast/anvil make that assumption true.
ARG WITH_FOUNDRY=1
RUN set -eux; \
    if [ "$WITH_FOUNDRY" = "1" ]; then \
      curl -fsSL https://foundry.paradigm.xyz | bash; \
      "$HOME/.foundry/bin/foundryup"; \
      "$HOME/.foundry/bin/forge" --version; \
    fi

# --- 18. Ruby (rbenv) + colorls ----------------------------------------------
# colorls is a gem, and the shell aliases ls/ll/la to it.
ARG WITH_RUBY=1
ARG RUBY_VERSION=4.0.2
RUN set -eux; \
    if [ "$WITH_RUBY" = "1" ]; then \
      git clone --depth 1 https://github.com/rbenv/rbenv.git "$HOME/.rbenv"; \
      git clone --depth 1 https://github.com/rbenv/ruby-build.git "$HOME/.rbenv/plugins/ruby-build"; \
      export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"; \
      rbenv install "$RUBY_VERSION"; \
      rbenv global "$RUBY_VERSION"; \
      gem install colorls --no-document; \
      rbenv rehash; \
      colorls --version; \
      rm -rf "$HOME/.rbenv/versions/$RUBY_VERSION/share/ri" "$HOME/.rbenv/versions/$RUBY_VERSION/share/doc"; \
    fi

# --- 19. Go (govman) ----------------------------------------------------------
# Off by default: gopls is configured in lsp.lua but Go is not part of the daily
# audit loop. --build-arg WITH_GO=1 to enable.
ARG WITH_GO=0
ARG GO_VERSION=1.25
RUN set -eux; \
    if [ "$WITH_GO" = "1" ]; then \
      curl -fsSL https://get.govman.dev/install.sh | bash; \
      "$HOME/.govman/bin/govman" init --shell zsh; \
      "$HOME/.govman/bin/govman" install "$GO_VERSION"; \
      "$HOME/.govman/bin/govman" use "$GO_VERSION"; \
      PATH="$HOME/.govman/bin:$HOME/go/bin:$PATH" go install golang.org/x/tools/gopls@latest; \
    fi

# --- 20. Repositories ---------------------------------------------------------
# Deliberately after every toolchain: this is the layer that changes whenever you
# push a dotfile, and everything below it is cheap to redo.
# --filter=blob:none rather than --depth 1 — small clone, but the full ref graph,
# so you can commit and push from inside the container.
# Pass the *_REF args a commit SHA (`run_docker.sh build --refresh` does this) to
# pin the build and to bust Docker's cache when upstream moves. The default,
# HEAD, means "whatever the clone checked out" — these repos do not agree on a
# default branch name (scripts/interdimux/tree-sitter-move-sui are on main,
# interdotensional on master).
ARG SCRIPTS_REF=HEAD
ARG INTERDOT_REF=HEAD
ARG INTERDIMUX_REF=HEAD
ARG TSMOVE_REF=HEAD
RUN set -eux; \
    clone() { git clone --filter=blob:none "$1" "$2" && { [ "$3" = HEAD ] || git -C "$2" checkout --quiet "$3"; }; }; \
    clone https://github.com/embe221ed/scripts              /opt/scripts                                   "$SCRIPTS_REF"; \
    clone https://github.com/embe221ed/interdotensional     /opt/tools/interdotensional                    "$INTERDOT_REF"; \
    clone https://github.com/embe221ed/interdimux           /opt/tools/interdimux                          "$INTERDIMUX_REF"; \
    clone https://github.com/embe221ed/tree-sitter-move-sui /opt/tree-sitter-parsers/tree-sitter-move-sui  "$TSMOVE_REF"; \
    test -f /opt/scripts/configs/zsh/zshrc || { \
      echo "ERROR: /opt/scripts/configs/zsh/zshrc is missing from the clone." >&2; \
      echo "       Commit and push configs/zsh/{zshrc,zshenv} to embe221ed/scripts first." >&2; exit 1; }

# --- 21. Generate + link the interdotensional configs -------------------------
# `generate` renders output/; `link` installs the symlinks declared in
# config/general.yml — $ZSH_CUSTOM/interdot.zsh (which is the only thing that
# exports DISPLAY_MODE and themes the syntax highlighter) and the prompt theme.
# Must run after oh-my-zsh exists.
RUN set -eux; \
    uv run --directory /opt/tools/interdotensional interdot generate; \
    uv run --directory /opt/tools/interdotensional interdot link; \
    test -L "$HOME/.oh-my-zsh/custom/themes/theme.zsh-theme"

# --- 22. Dotfiles -------------------------------------------------------------
# Symlinks into the repo, not `echo >>` appends: several settings (typeset -U,
# ZSH_THEME, plugins=(), fpath, ZSH_AUTOSUGGEST_STRATEGY, the nvm-lazy zstyle)
# only work above oh-my-zsh.sh and cannot be appended after it at all.
# Placed after every installer above, because rustup/nvm/foundryup append PATH
# lines to ~/.zshenv and ~/.zshrc — which would otherwise land in the repo files.
#
# ~/work is what run_docker.sh bind-mounts over; ~/.local/state has to exist and
# be user-owned before docker initialises the named volume from it. They are
# created here rather than next to the ENV block at step 10 so that they cost one
# cheap layer instead of invalidating every toolchain below.
RUN set -eux; \
    ln -sf /opt/scripts/configs/zsh/zshrc  "$HOME/.zshrc"; \
    ln -sf /opt/scripts/configs/zsh/zshenv "$HOME/.zshenv"; \
    mkdir -p "$HOME/.config" "$HOME/work" "$HOME/.local/state"; \
    ln -sfn /opt/scripts/configs/nvim "$HOME/.config/nvim"; \
    ln -sfn /opt/tools/interdotensional/output/colorls "$HOME/.config/colorls"; \
    ln -sf /opt/tools/interdotensional/output/tmux/.tmux.conf "$HOME/.tmux.conf"; \
    ln -sf languages.lua.sui /opt/scripts/configs/nvim/lua/languages.lua

# Container-only shell overlay, sourced by configs/zsh/zshrc after the theme.
RUN cat > "$HOME/.zshrc.local" <<'ZSHRC_LOCAL'
# Sourced by /opt/scripts/configs/zsh/zshrc — container-only settings.

# Keep the state worth keeping on the one path run_docker.sh puts a named volume
# on. zsh defaults HISTFILE to ~/.zsh_history and zoxide defaults its database to
# ~/.local/share/zoxide; neither is on the volume, so with --rm both would be
# thrown away at the end of every run.
export HISTFILE="$HOME/.local/state/zsh/history"
export _ZO_DATA_DIR="$HOME/.local/state/zoxide"
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# Docker-blue "❮dev❯" badge: the marker that says this shell is not the host.
# Same delimiter shape as the theme's own segments.
#
# Prepended from a precmd hook rather than by editing $PROMPT once, because the
# theme implements a transient prompt: a line-finish zle hook collapses PROMPT to
# a lone ❯, and its own precmd hook restores PROMPT from a snapshot taken when
# the theme loaded — i.e. before this file ran. Hooks fire in registration order,
# so a hook added here always runs after that restore and re-prepends the badge,
# without this file having to know the generated theme's private variables.
#
# _transient is redefined for the same reason: otherwise every line that has
# already run collapses to a bare ❯ identical to the host's, and the badge exists
# only on the prompt being typed on — nothing in the scrollback, and nothing in a
# tmux pane you left ten minutes ago, is marked.
#
# "dev" is the terminal's default foreground made bold, not a literal #ffffff:
# `interdot toggle` — and `run_docker.sh live`, which mounts the host's own
# generated output/ — flip the palette to light, where white on the light
# background #fbf1c7 is a 1.1:1 contrast ratio and the word simply vanishes.
if [[ -n "$DEV_CONTAINER" ]]; then
  _dev_badge='%{%F{#2496ED}%}❮%B%{%f%}dev%b%{%F{#2496ED}%}❯%{%f%k%b%u%} '

  autoload -Uz add-zsh-hook
  _dev_badge_precmd() {
    [[ $PROMPT == "$_dev_badge"* ]] || PROMPT="${_dev_badge}${PROMPT}"
  }
  add-zsh-hook precmd _dev_badge_precmd
  _dev_badge_precmd

  # Guarded, so this file stays valid if the theme is ever regenerated without a
  # transient prompt. $green/$reset are the theme's; re-read at call time.
  if (( $+functions[_transient] )); then
    _transient() { PROMPT="${_dev_badge}%{$green%}❯%{$reset%} "; RPS1=''; zle .reset-prompt }
  fi
fi
ZSHRC_LOCAL

# The same marker for the non-zsh ways in. `docker exec -it <c> bash` and
# `sudo -s` would otherwise be indistinguishable from a host shell.
# It has to go in the two ~/.bashrc files, not /etc/bash.bashrc: Ubuntu's skel
# .bashrc sets PS1 unconditionally and is sourced after the system one.
# env_keep is what carries DEV_CONTAINER across sudo's default env_reset.
RUN set -eux; \
    printf 'Defaults env_keep += "DEV_CONTAINER DISPLAY_MODE"\n' \
      | sudo tee /etc/sudoers.d/dev-container-env >/dev/null; \
    sudo chmod 0440 /etc/sudoers.d/dev-container-env; \
    badge='[ -n "$DEV_CONTAINER" ] && PS1="\[\e[38;2;36;150;237m\]❮\[\e[0m\]dev\[\e[38;2;36;150;237m\]❯\[\e[0m\] $PS1"'; \
    printf '%s\n' "$badge" >> "$HOME/.bashrc"; \
    printf '%s\n' "$badge" | sudo tee -a /root/.bashrc >/dev/null

# Git identity — otherwise the first commit inside the container aborts. Both are
# recorded in `docker history`, so pass empty strings if you ever share the image.
# safe.directory is scoped to the checkouts that can legitimately arrive from a
# bind mount with a different owner; a global '*' would switch the
# dubious-ownership check off everywhere, including for untrusted repos.
ARG GIT_USER_NAME=embe221ed
ARG GIT_USER_EMAIL=baniak996@gmail.com
RUN set -eux; \
    [ -z "$GIT_USER_NAME" ]  || git config --global user.name  "$GIT_USER_NAME"; \
    [ -z "$GIT_USER_EMAIL" ] || git config --global user.email "$GIT_USER_EMAIL"; \
    for d in /opt/scripts /opt/tools/interdotensional /opt/tools/interdimux \
             /opt/tree-sitter-parsers/tree-sitter-move-sui; do \
      git config --global --add safe.directory "$d"; \
    done

# Neovim has no clipboard provider in a container, and `clipboard=unnamedplus`
# disables the built-in OSC 52 fallback. Setting g:clipboard bypasses that guard,
# so yanks reach the host terminal over OSC 52.
RUN mkdir -p "$HOME/.local/share/nvim/site/plugin" \
 && printf 'vim.g.clipboard = "osc52"\n' > "$HOME/.local/share/nvim/site/plugin/clipboard.lua"

# --- 23. tmux plugins ---------------------------------------------------------
# The generated ~/.tmux.conf declares four TPM plugins and ends with
# `run '~/.tmux/plugins/tpm/tpm'`; without this every tmux start errors on that
# line and prefix+f / prefix+g / C-p / prefix+/ are dead.
# interdimux is symlinked to the repo checkout (as on the host) — TPM's
# already-installed check is satisfied by a symlink, so prefix+I skips it.
RUN set -eux; \
    mkdir -p "$HOME/.tmux/plugins"; \
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"; \
    ln -sfn /opt/tools/interdimux "$HOME/.tmux/plugins/interdimux"; \
    tmux new-session -d -s bootstrap sleep 120; \
    "$HOME/.tmux/plugins/tpm/bin/install_plugins"; \
    tmux kill-server; \
    test -d "$HOME/.tmux/plugins/tmux-fzf-links"; \
    test -d "$HOME/.tmux/plugins/tmux-fuzzback"

# interdimux's Rust core: up to ~7x faster rendering, and the bash fallback pads
# by character count, so wide/emoji session names misalign every column.
RUN set -eux; \
    . "$HOME/.cargo/env"; \
    cargo build --release --locked --manifest-path /opt/tools/interdimux/rust/Cargo.toml; \
    install -Dm755 /opt/tools/interdimux/rust/target/release/imux /opt/tools/interdimux/bin/imux; \
    rm -rf /opt/tools/interdimux/rust/target "$HOME/.cargo/registry" "$HOME/.cargo/git"; \
    /opt/tools/interdimux/bin/imux --version

# --- 24. Neovim warm-up -------------------------------------------------------
# Turns first-launch network failures into build failures, and makes the image
# usable offline. Parser installs are best-effort: they are re-tried lazily at
# runtime and a transient grammar fetch should not fail the whole build.
ARG WITH_NVIM_WARMUP=1
RUN set -eux; \
    if [ "$WITH_NVIM_WARMUP" = "1" ]; then \
      nvim --headless "+Lazy! sync" +qa; \
      nvim --headless \
        "+lua local ok,ts = pcall(require,'nvim-treesitter'); if ok then pcall(function() ts.install({'c','cpp','lua','rust','python','javascript','markdown','markdown_inline','bash','json','yaml','toml','move'}):wait(900000) end) end" \
        +qa || true; \
      test -d "$HOME/.local/share/nvim/lazy/lazy.nvim"; \
    fi

# --- 25. Entrypoint -----------------------------------------------------------
# atd is interdimux's job runner for the dashboard's Schedule/Jobs entries; there
# is no init system in the container, so start it here.
RUN sudo tee /usr/local/bin/dev-container-entrypoint >/dev/null <<'ENTRYPOINT' \
 && sudo chmod 755 /usr/local/bin/dev-container-entrypoint
#!/bin/sh
if command -v atd >/dev/null 2>&1 && ! pgrep -x atd >/dev/null 2>&1; then
  sudo /usr/sbin/atd 2>/dev/null || true
fi
exec "$@"
ENTRYPOINT

ENTRYPOINT ["/usr/local/bin/dev-container-entrypoint"]
CMD ["/usr/bin/zsh"]
