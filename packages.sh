#!/usr/bin/env bash

# Ensure script is run as root

if [ $UID -ne 0 ]; then
  echo "Script must be run as root"
  exit 1
fi

# Get Working Directory

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Get Logged In User and Homedir

USERNAME=$(who am i | awk '{print $1}')
HOMEDIR=$(eval echo ~$USERNAME)

PACKAGES=(
    alsa-base
    alsa-utils
    alsa-oss
    autoconf
    automake
    autotools-dev
    awesome
    awesome-extra
    build-essential
    consolekit
    digikam
    firmware-iwlwifi
    fonts-powerline
    gedit
    git
    gimp
    gimp-plugin-registry
    gnupg
    htop
    inkscape
    ksnapshot
    libasound2
    libasound2-doc
    linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')
    tree
    vim
    vlc
    xbacklight
    xorg
    zsh
)

# Install packages
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes ${PACKAGES[*]}

# Setup wifi
modprobe -r iwlwifi; \
modprobe iwlwifi

# Setup awesome
mkdir -p $HOMEDIR/.config/awesome
ln -s $DIR/awesome.lua $HOMEDIR/.config/rc.lua

# Setup zsh
ln -s $DIR/zsh $HOMEDIR/.zsh
ln $DIR/zsh/zshrc $HOMEDIR/.zshrc
ln -s $DIR/vim $HOMEDIR/.vim
ln $DIR/vim/vimrc $HOMEDIR/.vimrc
ln -s $DIR/xinitrc $HOMEDIR/.xinitrc

# Setup docker
curl -sSL https://get.docker.com/ | sh
usermod -aG docker "$USERNAME"
service docker restart
