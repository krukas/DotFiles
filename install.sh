#!/bin/bash
SCRIPT=`realpath -s $0`
SCRIPTPATH=`dirname $SCRIPT`
LEAP_VERSION=`grep VERSION= /etc/os-release | sed 's/VERSION="\|"//g'`

echo "Install applications"

# Add packman repo
sudo zypper ar -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_$LEAP_VERSION/ packman

# VLC + codec
sudo zypper install vlc ffmpeg lame gstreamer-plugins-bad gstreamer-plugins-ugly 
gstreamer-plugins-ugly-orig-addon gstreamer-plugins-libav libdvdcss2 vlc-codecs

# Sublime text
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo zypper install sublime-text git cpupower vim cmus



# I3 Environment
echo "Install and setup I3"
sudo zypper install i3 feh compton playerctl scrot dunst parcellite gcc-c++ hack-fonts rxvt-unicode w3m-inline-image

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

# Install cpupower.service
echo "Install and enable cpupower.service"
sudo cp "$SCRIPTPATH/systemd/cpupower.service" /etc/systemd/system/cpupower.service
sudo systemctl daemon-reload
sudo systemctl enable cpupower.service

# Create symlinks
echo "Create symlinks"
python3 SCRIPTPATH/files/create_symlinks.py


# Add sudoers rules
echo "Add sudoers rules"

echo "" | sudo tee /etc/sudoers.d/postgresql
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl start postgresql" | sudo tee /etc/sudoers.d/postgresql -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop postgresql" | sudo tee /etc/sudoers.d/postgresql -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart postgresql" | sudo tee /etc/sudoers.d/postgresql -a
sudo chmod 440 /etc/sudoers.d/postgresql

echo "" | sudo tee /etc/sudoers.d/openvpn
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl start openvpn" | sudo tee /etc/sudoers.d/openvpn@client -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop openvpn" | sudo tee /etc/sudoers.d/openvpn@client -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart openvpn" | sudo tee /etc/sudoers.d/openvpn@client -a
sudo chmod 440 /etc/sudoers.d/openvpn

echo "" | sudo tee /etc/sudoers.d/mysql
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl start mysql" | sudo tee /etc/sudoers.d/mysql -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop mysql" | sudo tee /etc/sudoers.d/mysql -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart mysql" | sudo tee /etc/sudoers.d/mysql -a
sudo chmod 440 /etc/sudoers.d/mysql

echo "" | sudo tee /etc/sudoers.d/rabbitmq-server
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl start rabbitmq-server" | sudo tee /etc/sudoers.d/rabbitmq-server -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl stop rabbitmq-server" | sudo tee /etc/sudoers.d/rabbitmq-server -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart rabbitmq-server" | sudo tee /etc/sudoers.d/rabbitmq-server -a
sudo chmod 440 /etc/sudoers.d/rabbitmq-server

echo "" | sudo tee /etc/sudoers.d/cpupower
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/cpupower frequency-set --max=2400mhz" | sudo tee /etc/sudoers.d/cpupower -a
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/cpupower frequency-set --max=3000mhz" | sudo tee /etc/sudoers.d/cpupower -a
sudo chmod 440 /etc/sudoers.d/cpupower
