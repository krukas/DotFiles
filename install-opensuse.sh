#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`
LEAP_VERSION=`grep VERSION= /etc/os-release | sed 's/VERSION="\|"//g'`

echo "Install applications"

# Add packman repo
sudo zypper ar -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$LEAP_VERSION/ packman

# VLC + codec
sudo zypper install --from packman vlc ffmpeg lame gstreamer-plugins-bad gstreamer-plugins-libav gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon libavcodec58 libavdevice58 libavfilter7 libavformat58 libavresample4 libavutil56 vlc-codecs

# Sublime text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo zypper install sublime-text git cpupower vim cmus htop fd meld keepassxc

# dev tools
sudo zypper install cmake gcc gcc-c++ postgresql postgresql-server postgresql-devel rabbitmq-server python3 python3-pip python3-devel python3-setuptools python3-cffi vagrant virtualbox

# Install pipx for installing python application in own inverionment 
pip3 install --user pipx

pipx install pgcli


# I3 Environment
echo "Install and setup I3"
sudo zypper install i3 i3blocks bc feh compton playerctl scrot dunst parcellite hack-fonts rxvt-unicode ranger w3m-inline-image wireless-tools

# Install j4-dmenu-desktop
git clone https://github.com/enkore/j4-dmenu-desktop.git j4dmenu-src && cd j4dmenu-src
cmake . && make && sudo make install
cd .. && rm -rf j4dmenu-src

# Enable gnome keyring on login
sudo grep -q -F 'auth optional pam_gnome_keyring.so' /etc/pam.d/login || echo 'auth optional pam_gnome_keyring.so' | sudo tee -a /etc/pam.d/login
sudo grep -q -F 'session    optional     pam_gnome_keyring.so auto_start' /etc/pam.d/login || echo 'session    optional     pam_gnome_keyring.so auto_start' | sudo tee -a /etc/pam.d/login

sudo grep -q -F 'password optional pam_gnome_keyring.so' /etc/pam.d/passwd || echo 'password optional pam_gnome_keyring.so' | sudo tee -a /etc/pam.d/passwd



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


# Add sudoers rules
echo "Add sudoers rules"


echo "" | sudo tee /etc/sudoers.d/iwgetid
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/iwgetid -r" | sudo tee /etc/sudoers.d/iwgetid -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/iwgetid -r" | sudo tee /etc/sudoers.d/iwgetid -a
sudo chmod 440 /etc/sudoers.d/iwgetid
