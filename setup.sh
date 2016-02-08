#!/usr/bin/env bash

# Define packages that will be installed

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
    bumblebee-nvidia
    digikam
    firmware-iwlwifi
    fonts-powerline
    freecad
    gdebi
    gedit
    gimp
    gimp-plugin-registry
    gnupg
    gtk-recordmydesktop
    htop
    inkscape
    ksnapshot
    libasound2
    libasound2-doc
    linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,')
    lxrandr
    nvidia-driver
    nvidia-xconfig
    postgresql-client
    primus
    primus-libs:i386
    python-crypto
    python-gpgme
    python-jinja2
    python-paramiko
    python-setuptools
    python-yaml
    transmission-gtk
    tree
    vim
    virtualbox
    vlc
    wicd
    xbacklight
    xorg
    zsh
)

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

# Get list of users that can log in

USERS=$(exec $DIR/users.sh)

# Useful Functions

Log() {
  if [ -z "$heading" ]; then
    echo "# $*"
  else
    echo "## $*"
  fi
}

runner() {
  echo "Running \`$*\`"
  echo "\`\`\`"
  bash -c "$*"
  echo "\`\`\`"
}

# Run Setup

heading='true' Log 'Updating System'
Log 'Including non-free packages'
# Don't error when sources.list.d is empty
shopt -s nullglob
NONFREE=$(cat /etc/apt/sources.list /etc/apt/sources.list.d/* | grep -v '^#' | grep 'deb.*main.*contrib.*non-free')
shopt -u nullglob
if [ -z "$NONFREE" ]; then
  # quoted to ensure >> gets run inside of runner
  runner \
    "echo 'deb http://httpredir.debian.org/debian/ jessie main contrib non-free' >> /etc/apt/sources.list"
else
  runner \
  echo "non-free repo installed, skipping step"
fi
Log 'Include i386'
runner \
  dpkg --add-architecture i386
Log 'Updating apt-get'
runner \
  apt-get update
Log 'Downloading new packages'
runner \
  DEBIAN_FRONTEND=noninteractive apt-get --download-only -y --force-yes dist-upgrade
Log 'Installing new packages'
runner \
  DEBIAN_FRONTEND=noninteractive apt-get -y --force-yes dist-upgrade
runner \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes ${PACKAGES[*]}
heading='true' Log 'Setting up hardware'
runner \
  modprobe -r iwlwifi; \
  modprobe iwlwifi
Log 'Adding users to bumblebee group'
for u in $USERS; do
  runner \
    id $u
  runner \
    usermod -aG bumblebee $u
  runner \
    id $u
done
Log 'Adding users to audio group'
for u in $USERS; do
  runner \
    id $u
  runner \
    usermod -aG audio $u
  runner \
    id $u
done
Log 'Moving asoundrc into place'
  runner \
    ln $DIR/asoundrc $HOMEDIR/.asoundrc
Log 'Setting up background rotation'
for u in $USERS; do
  runner \
    "(crontab -u $u -l; echo \"* * * * * DISPLAY=:0 $DIR/backgrounds/random.sh\") | crontab -u $u -"
done
heading='true' Log 'Terminal Environment'
Log 'Setting up Awesome'
runner \
  mkdir -p $HOMEDIR/.config/awesome
runner \
  ln -s $DIR/awesome.lua $HOMEDIR/.config/rc.lua
Log 'Setting zsh as default shell'
for u in $USERS; do
  runner \
    grep "^$u" /etc/passwd
  runner \
    chsh -s $(which zsh) $u
  runner \
    grep "^$u" /etc/passwd
done
Log 'Moving zsh dotfiles into place'
runner \
  ln -s $DIR/zsh $HOMEDIR/.zsh
runner \
  ln $DIR/zsh/zshrc $HOMEDIR/.zshrc
Log 'Moving vim dotfiles into place'
runner \
  ln -s $DIR/vim $HOMEDIR/.vim
runner \
  ln $DIR/vim/vimrc $HOMEDIR/.vimrc
Log 'Moving .Xresources into place'
runner \
  ln -s $DIR/Xresources $HOMEDIR/.Xresources
Log 'Moving .xinitrc into place'
runner \
  ln -s $DIR/xinitrc $HOMEDIR/.xinitrc
Log 'Installing Web Browser'
runner \
  gdebi -n \
    $DIR/debs/google_chrome.deb
Log 'Installing Dropbox'
runner \
  gdebi -n \
    $DIR/debs/dropbox.deb
Log 'Installing docker'
runner \
  curl -sSL https://get.docker.com/ | sh
runner \
  groupadd docker
runner \
  gpasswd -a $USERNAME docker
runner \
  service docker restart
Log 'Installing iojs'
runner \
  "curl -sL https://deb.nodesource.com/setup_iojs_2.x | bash -"
runner \
  apt-get install -y --force-yes \
    iojs
Log 'Installing nvm'
runner \
  "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash"
Log 'Installing webserver'
runner \
  npm install -g local-web-server
Log' Installing JavaScript Linter'
runner \
  npm install -g standard
Log 'Installing Ansible'
runner \
  git clone --recursive -b stable-1.9 --depth 1 git://github.com/ansible/ansible.git
runner \
  easy_install pip
runner \
  pip install paramiko PyYAML Jinja2 httplib2
runner \
  "cd ansible && make install"
Log 'Installing Anki'
runner \
  gdebi -n $DIR/debs/anki.deb
Log 'Installing Golang'
runner \
  "tar -C /usr/local -xzf $DIR/debs/go*.tar.gz"
Log 'Installing docker-compose'
runner \
  "curl -L https://github.com/docker/compose/releases/download/1.6.0/docker-compose-Linux-x86_64 > /usr/local/bin/docker-compose"
runner \
  chmod +x /usr/local/bin/docker-compose
Log 'Installing neovim'
runner \
  mkdir -p ~wblankenship/.bin
runner \
  "git clone https://github.com/neovim/neovim.git $DIR/neovim && cd $DIR/neovim && make CMAKE_EXTRA_FLAGS=\"-DCMAKE_NSTALL_PREFIX:PATH=~wblankenship/.bin && make install"
heading='true' Log "Rebooting"
runner \
  shutdown -r now
