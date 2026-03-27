#!/bin/bash
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
set -o xtrace

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLATFORM=$(uname)
IS_SYNOLOGY=false
if [ -f /proc/syno_platform ]; then
  IS_SYNOLOGY=true
fi

# Delete existing symlinks (or backup files if not symlinks)
backup_dir=""
if [[ $PLATFORM == "Linux" ]]; then
  backup_tmp_path=/tmp/dotfiles
  mkdir -p $backup_tmp_path
  backup_dir=`mktemp -p ${backup_tmp_path} -d`
elif [[ $PLATFORM == "Darwin" ]]; then
  backup_dir=`mktemp -d`
fi

# Helper to backup existing file/symlink and create new symlink
link_dotfile() {
  local target=$1
  local link_path=$2
  if [ -e $link_path ]; then mv $link_path $backup_dir; fi
  if [ -h $link_path ]; then rm $link_path; fi
  ln -s $target $link_path
}

# Install homebrew
if [[ $PLATFORM == "Darwin" ]]; then
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

cd $DOTFILES_DIR
git submodule init
git submodule update

# --- Core configs (all platforms) ---

link_dotfile $DOTFILES_DIR/zsh ~/.zsh
if [ -h ~/.zshrc ]; then rm ~/.zshrc; fi
ln -s $DOTFILES_DIR/zsh/zshrc ~/.zshrc

link_dotfile $DOTFILES_DIR/tmux.conf ~/.tmux.conf

if [[ $IS_SYNOLOGY == false ]]; then
  # --- Full configs ---

  mkdir -p ~/.config
  link_dotfile $DOTFILES_DIR/nvim ~/.config/nvim
  link_dotfile $DOTFILES_DIR/gitignore ~/.gitignore
  link_dotfile $DOTFILES_DIR/rgignore ~/.rgignore
  link_dotfile $DOTFILES_DIR/gitconfig ~/.gitconfig

  claude_settings_dir=~/.claude
  mkdir -p $claude_settings_dir
  link_dotfile $DOTFILES_DIR/claude/settings.json $claude_settings_dir/settings.json
  link_dotfile $DOTFILES_DIR/claude/commands $claude_settings_dir/commands
fi

if find "$backup_dir" -mindepth 1 -print -quit | grep -q .; then
  echo -e "\nExisting dotfiles moved to ${backup_dir}\n\tls -a ${backup_dir}\n"
fi

# Run local config init, if it exists.
localconfig_path=~/.config/local/init.sh
if [ -e $localconfig_path ]; then sh $localconfig_path; fi

if [[ $IS_SYNOLOGY == false ]]; then
  # Platform specific installation
  if [[ $PLATFORM == "Linux" ]]; then
    sudo apt-get install zsh tmux neovim fzf ripgrep cmake jq git-lfs
  elif [[ $PLATFORM == "Darwin" ]]; then
    brew install tmux nvim fzf ripgrep cmake jq git-lfs
  fi

  # Set zsh as default shell if it isn't already
  if [ "$(basename "$SHELL")" != "zsh" ] && command -v zsh &> /dev/null; then
    sudo chsh -s "$(which zsh)" "$USER"
  fi

  # Install Claude Code
  curl -fsSL https://claude.ai/install.sh | bash
fi
