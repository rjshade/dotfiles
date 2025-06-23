#!/bin/bash
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
set -o xtrace

DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLATFORM=$(uname)

# Delete existing symlinks (or backup files if not symlinks)
backup_dir=""
if [[ $PLATFORM == "Linux" ]]; then
  backup_tmp_path=/tmp/dotfiles
  mkdir -p $backup_tmp_path
  backup_dir=`mktemp -p ${backup_tmp_path} -d`
elif [[ $PLATFORM == "Darwin" ]]; then
  backup_dir=`mktemp -d`
fi

# Install homebrew
if [[ $PLATFORM == "Darwin" ]]; then
  if ! [ -x "$(command -v brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

cd $DOTFILES_DIR
git submodule init
git submodule update

nvim_path=~/.config/nvim
if [ -e $nvim_path ]; then mv $nvim_path $backup_dir; fi
if [ -h $nvim_path ]; then rm $nvim_path; fi
if ! ln -s $DOTFILES_DIR/nvim ~/.config/; then
  echo "Failed to create nvim symlink"
  exit 1
fi

zsh_path=~/.zsh
if [ -e $zsh_path ]; then mv $zsh_path $backup_dir; fi
if [ -h $zsh_path ]; then rm $zsh_path; fi
if ! ln -s $DOTFILES_DIR/zsh $zsh_path; then
  echo "Failed to create zsh symlink"
  exit 1
fi

zshrc_path=~/.zshrc
if [ -h $zshrc_path ]; then rm $zshrc_path; fi
if ! ln -s $DOTFILES_DIR/zsh/zshrc $zshrc_path; then
  echo "Failed to create zshrc symlink"
  exit 1
fi

tmux_conf_path=~/.tmux.conf
if [ -e $tmux_conf_path ]; then mv $tmux_conf_path $backup_dir; fi
if [ -h $tmux_conf_path ]; then rm $tmux_conf_path; fi
if ! ln -s $DOTFILES_DIR/tmux.conf $tmux_conf_path; then
  echo "Failed to create tmux.conf symlink"
  exit 1
fi

gitignore_path=~/.gitignore
if [ -e $gitignore_path ]; then mv $gitignore_path $backup_dir; fi
if [ -h $gitignore_path ]; then rm $gitignore_path; fi
if ! ln -s $DOTFILES_DIR/gitignore $gitignore_path; then
  echo "Failed to create gitignore symlink"
  exit 1
fi

rgignore_path=~/.rgignore
if [ -e $rgignore_path ]; then mv $rgignore_path $backup_dir; fi
if [ -h $rgignore_path ]; then rm $rgignore_path; fi
if ! ln -s $DOTFILES_DIR/rgignore $rgignore_path; then
  echo "Failed to create rgignore symlink"
  exit 1
fi

gitconfig_path=~/.gitconfig
if [ -e $gitconfig_path ]; then mv $gitconfig_path $backup_dir; fi
if [ -h $gitconfig_path ]; then rm $gitconfig_path; fi
if ! ln -s $DOTFILES_DIR/gitconfig $gitconfig_path; then
  echo "Failed to create gitconfig symlink"
  exit 1
fi

if find "$backup_dir" -mindepth 1 -print -quit | grep -q .; then
  echo -e "\nExisting dotfiles moved to ${backup_dir}\n\tls -a ${backup_dir}\n"
fi

# Run local config init, if it exists.
localconfig_path=~/.config/local/init.sh
if [ -e $localconfig_path ]; then sh $localconfig_path; fi

# Platform specific installation
if [[ $PLATFORM == "Linux" ]]; then
  sudo apt-get install tmux nvim fzf ripgrep cmake jq git-lfs
elif [[ $PLATFORM == "Darwin" ]]; then
  brew install tmux nvim fzf ripgrep cmake jq git-lfs
fi
