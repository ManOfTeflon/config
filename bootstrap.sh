#!/bin/bash

set -e
set -x

fatal ()
{
    echo $@ >2
    exit 1
}

if (uname -a | grep -iq ubuntu); then
    dist="ubuntu"
else
    fatal "Unsupported linux distribution"
fi

sudo sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
sudo usermod -aG sudo $USER

case "${dist}" in
    ubuntu)
        sudo apt-get install -y git
        ;;
    *)
        fatal "Unsupported linux distribution"
        ;;
esac

cd $HOME

git clone https://github.com/ManOfTeflon/config.git

mv config/.git .
rm -rf config/
git reset --hard HEAD

case "${dist}" in
    ubuntu)
        sudo apt-get install -y vim-nox-py2 tmux ipython gdb unclutter compton feh ruby-dev build-essential cmake python-dev python3-dev source-highlight expect xsel openssh-server
        ;;
    *)
        fatal "Unsupported linux distribution"
        ;;
esac

ln -s .vim/.vimrc .

mkdir -p "${HOME}/.local"
cd "${HOME}/.local"

source_highlight_datadir=$(echo n | source-highlight-settings | awk '/the current datadir is:/ { print $5; }')
git clone https://github.com/jrunning/source-highlight-solarized.git

cd source-highlight-solarized
sudo ln -s $(pwd)/esc-solarized.outlang "${source_highlight_datadir}"
sudo ln -s $(pwd)/esc-solarized.style "${source_highlight_datadir}"

git clone https://github.com/powerline/fonts.git
cd fonts
./install.sh

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle

vim -c BundleInstall

cd "${HOME}/.vim/bundle/Command-T/ruby/command-t/ext/command-t"
ruby extconf.rb
make

cd "${HOME}/.vim/bundle/YouCompleteMe"
./install.py --clang-completer

