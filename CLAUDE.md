# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files for a development environment including Neovim, tmux, zsh, and git. The repository is designed to work on both Linux and macOS systems.

## Setup and Installation

The repository uses a central installation script:
- **Installation**: Run `sh ~/.dotfiles/init.sh` to install and symlink all configurations
- The script handles platform detection (Linux/macOS) and installs required packages via apt/homebrew
- Creates symlinks for all configuration files in appropriate locations
- Backs up existing configurations to a temporary directory

## Core Configuration Structure

### Neovim Configuration (`nvim/`)
- **Entry point**: `nvim/init.lua` loads core modules and plugins
- **Plugin management**: Uses lazy.nvim package manager
- **Core modules**: Located in `nvim/lua/core/` (options, keymaps)
- **Plugins**: Individual plugin configs in `nvim/lua/plugins/`
- **Key plugins**: LSP (nvim-lspconfig), Mason (LSP installer), Copilot, fzf, nvim-tree
- **Color scheme**: Tomorrow-Night theme

### Shell Configuration (`zsh/`)
- **Main config**: `zsh/zshrc` sources all files in `zsh/zsh.d/`
- **Environment**: `0_env.zsh` - paths, history, platform detection
- **Aliases**: `1_aliases.zsh` - extensive command aliases and functions  
- **Prompt**: `2_prompt.zsh` - shell prompt configuration
- **Integration**: fzf, syntax highlighting, autojump support

### Terminal Multiplexer (`tmux.conf`)
- **Prefix**: Uses Ctrl-a instead of Ctrl-b
- **Navigation**: Vim-style hjkl pane movement
- **Splits**: | and - for horizontal/vertical splits
- **Copy mode**: Vi-style keybindings for selection and copying

## Key Commands and Workflows

### Installation Dependencies
```bash
# macOS
brew install tmux nvim fzf ripgrep cmake jq git-lfs

# Linux  
sudo apt-get install tmux nvim fzf ripgrep cmake jq git-lfs
```

### Git Workflow (via zsh aliases)
- `g` - git status
- `gl` - formatted git log with graph
- `gco` - git checkout
- `gb` - git branch
- `gd` - git diff
- `gm` - list files changed vs main branch
- `ghpr()` - create GitHub PR with auto-merge enabled
- `am` - watch PR checks and auto-merge when ready

### Neovim Key Bindings
- **Leader key**: `,` (comma)
- **LSP navigation**: `gd` (definition), `gr` (references), `gh` (hover), `gc` (code actions)
- **File tree**: `Ctrl-n` or `<leader>e` to toggle NvimTree
- **Window navigation**: `Ctrl-hjkl` to move between splits
- **Formatting**: `gf` or `<leader>F` to format code

### tmux Key Bindings  
- **Prefix**: `Ctrl-a`
- **Pane navigation**: `Ctrl-a hjkl`
- **Split windows**: `Ctrl-a |` (horizontal), `Ctrl-a -` (vertical)
- **Copy mode**: `Ctrl-a [` to enter, `v` to select, `y` to copy
- **Reload config**: `Ctrl-a r`

## Development Environment Features

### Editor Configuration
- 2-space indentation for all files
- Line numbers enabled
- Smart case-insensitive search
- LSP integration with hover, definitions, and code actions
- Automatic formatting capabilities
- Syntax highlighting and git status in sidebar

### Shell Features
- Extensive history (100k entries with timestamps)
- Platform-specific command aliases
- Directory navigation helpers (`gr` for git root, `find_parent_dir`)
- File extraction function `ex()` for various archive formats
- Integration with fzf for fuzzy finding and history search

### Terminal Environment
- 256-color support across all tools
- Vi-style keybindings where applicable
- Mouse support in tmux for scrolling and pane selection
- Seamless integration between nvim, tmux, and shell

## Local Customization

The configuration supports local machine-specific customization:
- `~/.config/local/nvim/local.lua` - Additional nvim configuration
- `~/.config/local/zshrc` - Additional zsh configuration  
- `~/.config/local/init.sh` - Additional setup steps

This allows for machine-specific settings without modifying the main dotfiles repository.