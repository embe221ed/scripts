# scripts

Utilities, CTF tooling, and the dev container image.

| Directory | What |
|---|---|
| `utils/` | Standalone helpers: `determine_system.sh` (OS detection), `display_mode.sh` (light/dark toggle via interdotensional), `build_nvim.sh`, `export_to_pdf.sh`, `watermark.py` |
| `pwn/` | Binary exploitation: glibc build/install, kernel initramfs pack/unpack/run + QEMU, v8 and SpiderMonkey harnesses, a pwntools Dockerfile |
| `PoW/` | Proof-of-work clients for CTF challenge gateways |
| `build/` | Build inputs that are not configuration — currently the Iosevka private build plan |
| `devcontainer/` | The dev container image: `devContainer.dockerfile`, `run_docker.sh`, and its own README |
| `configs/` | **Tombstones only.** See below. |

## The personal dotfiles moved

They now live in **[embe221ed/dotfiles](https://github.com/embe221ed/dotfiles)** —
zsh, neovim, shell completions, and terminal themes:

```sh
git clone https://github.com/embe221ed/dotfiles /opt/dotfiles
/opt/dotfiles/install.sh
```

`configs/` still holds three files — `zsh/zshrc`, `zsh/zshenv` and
`nvim/init.lua` — and they are **tombstones**, not configuration. Each warns that
the dotfiles moved and then chains into `/opt/dotfiles` if it finds a clone, so a
machine that was never migrated keeps working and tells you what to run.

**They are scheduled for deletion after 2026-08-12.** If you are reading this
after that date and they are still here, a machine somewhere was never cut over.

The dotfiles' full history came with them: `embe221ed/dotfiles` carries 339
commits, extracted with `git filter-repo`. This repository keeps the same history
under its old `configs/` paths, so anything pruned during the split — the
tmux-powerline themes, the ghostty shaders, the pre-split oh-my-zsh themes — is
recoverable from **this** repo's log, not from the dotfiles one.

## Three repos, one environment

| Repo | Owns |
|---|---|
| **scripts** (this) | utilities, CTF tooling, the container image — and `utils/determine_system.sh`, which the dotfiles resolve **by name**, never by path |
| [**dotfiles**](https://github.com/embe221ed/dotfiles) | zsh, neovim, completions, kitty themes, blink, ipython, colorls, silicon |
| [**interdotensional**](https://github.com/embe221ed/interdotensional) | the theme generator: one palette rendered into nvim, kitty, ghostty, tmux, zsh, zellij, ipython, fzf and colorls configs |

The dev container clones all three.

Licence: MIT (`LICENSE`).
