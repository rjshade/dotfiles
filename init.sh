#!/bin/bash
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
set -o xtrace

: ${DOTFILES:?"Need to set DOTFILES to point to dotfiles repository"}

if [ ! -d "$DOTFILES" ]; then
  echo "\$DOTFILES needs to be a directory"
  exit
fi

# Delete existing symlinks (or backup files if not symlinks)
backup_tmp_path=/tmp/dotfiles
mkdir -p $backup_tmp_path
backup_dir=`mktemp -p ${backup_tmp_path} -d`

cd $DOTFILES
git submodule init
git submodule update

# Need python support for YouCompleteMe in neovim
pip2 install --user --upgrade neovim
pip3 install --user --upgrade neovim

vim_path=~/.vim
if [ -e $vim_path ]; then mv $vim_path $backup_dir; fi
ln -s $DOTFILES/vim $vim_path
rm -rf ~/.vim-tmp
mkdir ~/.vim-tmp
rm -rf $vim_path/bundle/Vundle.vim
git clone https://github.com/gmarik/Vundle.vim.git $vim_path/bundle/Vundle.vim

vimrc_path=~/.vimrc
if [ -e $vimrc_path ]; then mv $vimrc_path $backup_dir; fi
ln -s $DOTFILES/vim/vimrc $vimrc_path
vim +PluginInstall +qall

mkdir -p ~/.config/nvim
nvim_init_path=~/.config/nvim/init.vim
if [ -e $nvim_init_path ]; then mv $nvim_init_path $backup_dir; fi
echo -e "set runtimepath^=${vim_path} runtimepath+=${vim_path}/after\n"\
        "let &packpath = &runtimepath\n"\
        "source ${vimrc_path}" > $nvim_init_path

fzf_path=~/.fzf
if [ -e $fzf_path ]; then mv $fzf_path $backup_dir; fi
ln -s $DOTFILES/fzf $fzf_path
(yes | $fzf_path/install) || true

zsh_path=~/.zsh
if [ -e $zsh_path ]; then mv $zsh_path $backup_dir; fi
ln -s $DOTFILES/zsh ~/.zsh

zshrc_path=~/.zshrc
if [ -e $zshrc_path ]; then mv $zshrc_path $backup_dir; fi
ln -s $DOTFILES/zsh/zshrc ~/.zshrc

tmux_conf_path=~/.tmux.conf
if [ -e $tmux_conf_path ]; then mv $tmux_conf_path $backup_dir; fi
ln -s $DOTFILES/tmux.conf ~/.tmux.conf

gitignore_path=~/.gitignore
if [ -e $gitignore_path ]; then mv $gitignore_path $backup_dir; fi
ln -s $DOTFILES/gitignore ~/.gitignore

gitconfig_path=~/.gitconfig
if [ -e $gitconfig_path ]; then mv $gitconfig_path $backup_dir; fi
ln -s $DOTFILES/gitconfig ~/.gitconfig

if find "$backup_dir" -mindepth 1 -print -quit | grep -q .; then
  echo -e "\nExisting dotfiles moved to ${backup_dir}\n\tls -a ${backup_dir}\n"
fi
