#!/bin/bash

: ${DOTFILES:?"Need to set DOTFILES to point to dotfiles repository"}

if [ ! -d "$DOTFILES" ]; then
  echo "\$DOTFILES needs to be a directory"
  exit
fi

cd $DOTFILES
git submodule init
git submodule update

ln -s $DOTFILES/vim ~/.vim
ln -s $DOTFILES/vim/vimrc ~/.vimrc
ln -s $DOTFILES/zsh ~/.zsh
ln -s $DOTFILES/zsh/zshrc ~/.zshrc
ln -s $DOTFILES/tmux.conf ~/.tmux.conf
ln -s $DOTFILES/gitignore ~/.gitignore
ln -s $DOTFILES/gitconfig ~/.gitconfig
ln -s $DOTFILES/ackrc ~/.ackrc
