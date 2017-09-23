#!/bin/bash

fatal ()
{
    echo $@ >2
    exit 1
}

cd $HOME
config_dir="$( cd "$( dirname $( realpath "${BASH_SOURCE[0]}" ) )/.." && pwd )"

if (uname -a | grep -iq ubuntu); then
    dist="ubuntu"
else
    fatal "Unsupported linux distribution"
fi

mv "${config_dir}/.git" .
rm -rf "${config_dir}"
git reset --hard HEAD

echo "Add NOPASSWD: to the sudo or wheel user group"
read
sudo visudo

case "${dist}" in
    ubuntu)
        sudo apt-get install vim-nox-py2 tmux ipython gdb unclutter compton feh ruby-dev build-essential cmake python-dev python3-dev source-highlight expect xsel
        ;;
    *)
        fatal "Unsupported linux distribution"
        ;;
esac

mkdir -p "${HOME}/.local"
cd "${HOME}/.local"

source_highlight_datadir=$(echo n | source-highlight-settings | awk '/the current datadir is:/ { print $5; }')
git clone https://github.com/jrunning/source-highlight-solarized.git
cd source-highlight-solarized
sudo ln -s $(pwd)/esc-solarized.outlang "${source_highlight_datadir}"
sudo ln -s $(pwd)/esc-solarized.style "${source_highlight_datadir}"

exit 0

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

