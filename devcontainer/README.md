# devContainer

A container that replicates the host dev environment: zsh + oh-my-zsh driven by
the [interdotensional](https://github.com/embe221ed/interdotensional) theme
pipeline, tmux with [interdimux](https://github.com/embe221ed/interdimux), the
neovim config from `configs/nvim`, and the toolchains behind the LSP servers that
config expects.

## Run

The image is self-contained. From anywhere, with nothing else installed:

```sh
docker run --rm -it dev-container:latest
```

That gives you the full environment — prompt, theme, tmux + interdimux, neovim,
LSPs — and lands you in `~`. The `❮dev❯` badge on the prompt is how you tell a
container shell from a host shell: it stays on lines that have already run (the
theme collapses those to a bare `❯`, which is exactly what the host shows), and
it is on `docker exec … bash` and `sudo -s` too.

`run_docker.sh` is a convenience wrapper, never a requirement. It adds only the
things the image cannot know about itself:

```sh
./run_docker.sh build              # build (passes your uid/gid through)
./run_docker.sh build --refresh    # …and pin every clone to current upstream HEAD
./run_docker.sh                    # run: $PWD at ~/work, your $TERM, ssh agent, state volume
./run_docker.sh live               # …plus /opt/scripts and /opt/tools bind-mounted
```

| Wrapper adds | Bare `docker run` instead gets | Worth a flag? |
|---|---|---|
| `-e TERM=$TERM` | `xterm-256color` from the image | only if the outer terminal is ghostty and you want its exact terminfo. The wrapper checks the entry exists in the image first and falls back — tmux refuses to start on an unknown `TERM`, and `xterm-kitty` is not in the image |
| `$PWD` → `~/work` | empty `~/work` in the image | add `-v "$PWD:/home/embe221ed/work" -w /home/embe221ed/work` to work on a checkout |
| ssh agent | no agent | add `-v "$SSH_AUTH_SOCK:/ssh-agent" -e SSH_AUTH_SOCK=/ssh-agent` to push |
| `dev-container-state` volume | state discarded on exit | add `-v dev-container-state:/home/embe221ed/.local/state` to keep zsh history, the zoxide db and nvim's shada/undo |

`COLORTERM` is *not* forwarded — the image asserts `COLORTERM=truecolor` itself.
Without it fast-syntax-highlighting loads `zsh/nearcolor` and quantises every
24-bit colour in the theme (and in the `❮dev❯` badge) down to 256.

## Build

```sh
./run_docker.sh build
```

Or by hand — BuildKit is required (`TARGETARCH`, heredocs):

```sh
docker buildx build -f devContainer.dockerfile -t dev-container \
  --build-arg USER_UID=$(id -u) --build-arg USER_GID=$(id -g) .
```

> **The build clones `embe221ed/scripts` from GitHub.** Changes to
> `configs/zsh/*`, `configs/nvim/*` … only reach the image once they are
> **committed and pushed** — the build fails with an explicit message if
> `configs/zsh/zshrc` is missing from the clone. `run_docker.sh live`
> bind-mounts the host checkouts over the image's copies, which is the fast way
> to iterate without rebuilding.

The clone layer deliberately sits *below* every toolchain, so `--refresh` (or
any dotfile push) rebuilds only the last handful of cheap layers — not CPython,
rustup, node, ruby and the nvim warm-up.

`$SSH_AUTH_SOCK` is forwarded when set, so `git push` works from inside the
container against the SSH remotes. `$HOME/.local/state` is a named volume
(`dev-container-state`), and `~/.zshrc.local` points `HISTFILE` and
`$_ZO_DATA_DIR` into it, so shell history, the zoxide database and nvim's
shada/undo survive `--rm`.

> Images and the volume were named `devcontainer`/`devcontainer-state` before.
> To carry the old state over once:
> ```sh
> docker run --rm -v devcontainer-state:/from -v dev-container-state:/to \
>   alpine sh -c 'cp -a /from/. /to/' && docker volume rm devcontainer-state
> ```

> **Security note.** `live` mounts your real dotfiles read-write and forwards
> your ssh agent into a container that has NOPASSWD sudo. Code running in there
> can rewrite `configs/zsh/zshrc`, which your *host* shell then sources. Use
> plain `run` when the working directory holds code you don't trust.

## What's in it

| Component | Version / source | Why not the distro package |
|---|---|---|
| neovim | `NVIM_VERSION` (v0.12.4) | config needs `vim.lsp.config` (≥ 0.11) |
| tmux | built from source, `TMUX_VERSION` (3.7b) | noble ships 3.4; interdimux needs ≥ 3.6 and the generated conf uses `new-pane` (3.7) |
| fzf | `FZF_VERSION` (0.74.2) | noble ships 0.44; interdimux degrades silently below 0.74, `fzf --zsh` needs ≥ 0.48 |
| tree-sitter CLI | `TS_CLI_VERSION` (v0.26.11) | nvim-treesitter `main` shells out to it; apt has 0.20.8 |
| lua-language-server | `LUALS_VERSION` (3.18.2) | no apt package |
| clangd | `clangd-18` from apt | — |
| Python | pyenv, `PYTHON_VERSION` | `@fzf-links-python` points at `~/.pyenv/shims/python3`, which exists only once a version is installed |
| Rust | rustup + `rust-analyzer`, `rust-src`, `clippy`, `rustfmt` | `--profile minimal` alone leaves rustaceanvim with no server |
| Node | nvm, LTS + solidity-ls, solhint, ts_ls, bash-ls | those LSPs are configured in `lsp.lua` but never start without node |
| Ruby | rbenv, `RUBY_VERSION` + colorls | `ls`/`ll`/`la` are aliased to colorls |
| Sui / Move | `svm install latest` → `sui`, `move-analyzer` | the LSP for the primary audit language |
| Foundry | `foundryup` | `lsp.lua` uses `foundry.toml` as the solidity root marker |

Also baked in: the `tree-sitter-move-sui` grammar at
`/opt/tree-sitter-parsers/` (the path `languages.lua.sui` hardcodes), TPM with
all four tmux plugins pre-installed, interdimux's Rust core compiled to
`bin/imux`, and a warmed lazy.nvim plugin set.

## Build args

| Arg | Default | Notes |
|---|---|---|
| `USER_UID` / `USER_GID` | `1337` | pass your own so bind mounts stay writable both ways |
| `WITH_SUI` | `1` | the largest single component (~400 MB) |
| `WITH_NODE` | `1` | node LTS + 4 npm language servers/linters |
| `WITH_RUBY` | `1` | needed for `colorls`, i.e. the `ls` alias |
| `WITH_FOUNDRY` | `1` | forge/cast/anvil |
| `WITH_GO` | `0` | `gopls` is configured but Go isn't in the daily loop |
| `WITH_NVIM_WARMUP` | `1` | pre-installs plugins + parsers; skip for a faster build |
| `SCRIPTS_REF` … `TSMOVE_REF`, `SVM_REF` | `HEAD` | `HEAD` = whatever the clone checked out (the repos don't share a default branch name — `interdotensional` is on `master`). Pass a SHA to pin and to bust the layer cache; `build --refresh` does this for you |
| `GIT_USER_NAME` / `GIT_USER_EMAIL` | host values | recorded in `docker history` — pass empty strings if you share the image |

Not installed, deliberately: `jdtls` (~400 MB JDK), `texlab`, the Cadence
language server (`flow`). Their `lsp.lua` blocks are inert but cost nothing.
Binary-exploitation tooling lives in `pwn/binexp/docker-ctf-pwn` instead — that
image needs `--cap-add=SYS_PTRACE`, which shouldn't be granted here.

## Verifying an image

```sh
locale                                        # LANG=C.UTF-8
tmux -V; fzf --version; tree-sitter --version # 3.7b / ≥0.74 / ≥0.26.1
zsh -ic 'echo $ZSH_THEME $DISPLAY_MODE $SAVEHIST'      # theme Dark 50000
zsh -ic 'print -l $path' | sort | uniq -d              # empty — typeset -U works
ls -la ~/.oh-my-zsh/custom/themes/theme.zsh-theme      # symlink from `interdot link`
~/.tmux/plugins/interdimux/scripts/interdimux.sh --doctor
nvim --headless '+Lazy! check' +qa                     # nothing pending => warm
for b in rust-analyzer move-analyzer clangd lua-language-server \
         nomicfoundation-solidity-language-server bash-language-server forge; do
  printf '%-45s %s\n' "$b" "$(command -v $b || echo MISSING)"; done
```
