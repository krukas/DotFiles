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
  vim
  # Media
  ubuntu-restricted-extras
  vlc
  # Development
  build-essential
  gettext
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
  # Pyenv
  libssl-dev
  zlib1g-dev
  libbz2-dev
  libreadline-dev
  libsqlite3-dev
  wget
  curl
  llvm
  libncursesw5-dev
  xz-utils
  tk-dev
  libxml2-dev
  libxmlsec1-dev
  libffi-dev
  liblzma-dev
)

sudo apt-get update
sudo apt-get install --assume-yes ${packagelist[@]}


# Install pipx for installing python application in own inverionment 
pip3 install --user pipx

pipx install black isort


# Install pyenv
if [ ! -d "$HOME/.pyenv" ]
then
  echo "Install pyenv"
  git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  git clone https://github.com/jawshooah/pyenv-default-packages.git ~/.pyenv/plugins/pyenv-default-packages
  echo "ipdb" >> ~/.pyenv/default-packages
  cd ~/.pyenv && src/configure && make -C src
  cd $SCRIPTPATH
fi


# Setup postgresql
sudo runuser postgres -c "psql -c \"CREATE ROLE $(whoami) LOGIN SUPERUSER PASSWORD '$(whoami)';\""


# Update submodules
echo "Update submodles"
git submodule update --init --recursive

# Install powerline fonts
mkdir /tmp/powerline
git clone https://github.com/powerline/fonts.git /tmp/powerline --depth=1
source /tmp/powerline/install.sh
rm -rf /tmp/powerline


# Create symlinks
echo "Create symlinks"
python3 $SCRIPTPATH/files/create_symlinks.py
