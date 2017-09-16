#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

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
rm -rf ~/.vim
ln -sf "$SCRIPTPATH/vim" ~/.vim
ln -sf "$SCRIPTPATH/vimrc" ~/.vimrc
ln -sf "$SCRIPTPATH/bashrc" ~/.bashrc
ln -sf "$SCRIPTPATH/tmux.conf" ~/.tmux.conf

