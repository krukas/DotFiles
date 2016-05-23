#!/bin/bash

# Update submodules
echo "Update submodles"
git submodule update --init --recursive

# Install dep for YouCompleteMe
echo "Install dependencies for YouCompleteMe"
sudo apt-get install build-essential cmake python-dev python3-dev

# Install YouCompleteMe
echo "Install YoucompleteMe"
python vim/bundle/YouCompleteMe/install.py

# Create symlinks
echo "Create symlinks"
ln -s vim ~/.vim
ln -s vimrc ~/.vimrc
ln -s bashrc ~/.bashrc
ln -s tmux.conf ~/.tmux.conf

