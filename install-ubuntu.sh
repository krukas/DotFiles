#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

# Ensure apt is set up to work with https sources
sudo apt-get install --reinstall apt-transport-https ca-certificates


# Add Sublime repo
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo "deb [trusted=yes] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

packagelist=(
  gnome-session
  gnome-tweaks
  sublime-text
  # Media
  ubuntu-restricted-extras
  vlc
  # Development
  build-essential
  virtualbox
  vagrant
  meld
  # Postgresql
  postgresql
  postgresql-contrib
  # Rabbitmq server
  rabbitmq-server
  # Python
  python3
  python3-pip
  python3-dev
  python3-setuptools
  python3-wheel
  python3-cffi
)

sudo apt-get update
sudo apt-get install --assume-yes ${packagelist[@]}


# Install pipx for installing python application in own inverionment 
pip3 install --user pipx

pipx install black isort


# Create symlinks
echo "Create symlinks"
python3 $SCRIPTPATH/files/create_symlinks.py
