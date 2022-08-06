#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`

# Ensure apt is set up to work with https sources
sudo apt-get install --reinstall apt-transport-https ca-certificates curl gnupg lsb-release


# Add docker repo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Add Sublime repo
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/sublimehq-pub.gpg
echo "deb [trusted=yes] https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# Add NordVpn repo
curl -fsSL https://repo.nordvpn.com/gpg/nordvpn_public.asc | sudo gpg --dearmor -o /etc/apt/keyrings/nordvpn.gpg
echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" | sudo tee /etc/apt/sources.list.d/nordvpn.list

# Add Spotify repo
curl -fsSL https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

packagelist=(
  gnome-session
  gnome-tweaks
  # Applications
  nordvpn
  keepassxc
  chromium-browser
  evolution
  steam
  spotify-client
  # Media
  ubuntu-restricted-extras
  vlc
  # Development
  sublime-text
  build-essential
  gettext
  virtualbox
  vagrant
  meld
  dbeaver-ce
  # Docker
  docker-ce
  docker-ce-cli
  containerd.io
  docker-compose-plugin
  # KVM (for minikube)
  bridge-utils
  cpu-checker
  libvirt-clients
  libvirt-daemon
  libvirt-daemon-system
  qemu
  qemu-kvm
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


# install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null

# Install minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
minikube completion bash | sudo tee /etc/bash_completion.d/minikube > /dev/null
sudo usermod -aG libvirt $USER
minikube config set driver kvm2
minikube addons enable ingress


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


# Install gnome shell extensions
echo "Install gnome shell extensions"
$SCRIPTPATH/install/install-gnome-extension.sh "appindicatorsupport@rgcjonas.gmail.com"
$SCRIPTPATH/install/install-gnome-extension.sh "gnordvpn-local@isopolito"
$SCRIPTPATH/install/install-gnome-extension.sh "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
$SCRIPTPATH/install/install-gnome-extension.sh "places-menu@gnome-shell-extensions.gcampax.github.com"
$SCRIPTPATH/install/install-gnome-extension.sh "user-theme@gnome-shell-extensions.gcampax.github.com"
$SCRIPTPATH/install/install-gnome-extension.sh "drive-menu@gnome-shell-extensions.gcampax.github.com"
$SCRIPTPATH/install/install-gnome-extension.sh "middleclickclose@paolo.tranquilli.gmail.com"
$SCRIPTPATH/install/install-gnome-extension.sh "Resource_Monitor@Ory0n"
$SCRIPTPATH/install/install-gnome-extension.sh "scroll-workspaces@gfxmonk.net"
$SCRIPTPATH/install/install-gnome-extension.sh "gnome-ui-tune@itstime.tech"


# Import dconf
echo "Import Gnome dconf settings"
dconf load / < $SCRIPTPATH/install/dconf.export


# Create symlinks
echo "Create symlinks"
python3 $SCRIPTPATH/files/create_symlinks.py

echo "restart required"