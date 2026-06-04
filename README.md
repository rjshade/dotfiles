# dotfiles for Linux/macOS

Personal configuration for zsh, tmux, Neovim, git, and ripgrep.

## Install

```sh
git clone git@github.com:rjshade/dotfiles.git ~/.dotfiles
sh ~/.dotfiles/init.sh
```

`init.sh`:
- backs up any existing files it's about to replace (it prints the backup dir),
- symlinks the configs into place,
- initializes the `zsh-syntax-highlighting` submodule,
- installs dependencies via `brew` (macOS) or `apt-get` (Linux).

Set `DEBUG=1 sh ~/.dotfiles/init.sh` to trace each command.

On a Synology NAS (detected via `/proc/syno_platform`) only the minimal zsh +
tmux configs are installed.

## Layout

| Path             | Symlinked to        |
| ---------------- | ------------------- |
| `zsh/`           | `~/.zsh`            |
| `zsh/zshrc`      | `~/.zshrc`          |
| `tmux.conf`      | `~/.tmux.conf`      |
| `nvim/`          | `~/.config/nvim`    |
| `gitconfig`      | `~/.gitconfig`      |
| `gitignore`      | `~/.gitignore`      |
| `ripgreprc`      | `~/.ripgreprc`      |

## Machine-specific overrides

Loaded if present, so they can stay out of this repo:
- `~/.config/local/zshrc` — extra zsh config
- `~/.config/local/gitconfig` — e.g. work email override
- `~/.config/local/init.sh` — extra install steps
- `~/.config/local/nvim/local.lua` — extra Neovim config
