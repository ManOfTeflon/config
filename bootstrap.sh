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
        sudo apt-get install vim-nox-py2 tmux ipython gdb
        ;;
    *)
        fatal "Unsupported linux distribution"
        ;;
esac

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
vim -c BundleInstall

