#!/usr/bin/env bash

CURRENT=`pwd`

PACKAGE='git git-core curl terminator'

sudo apt-get install $PACKAGE

if [ -f ~/.gitconfig ] ; then
    cat ~/.gitconfig > ~/gitconfig.backup
    rm -f ~/.gitconfig
    echo "Existing .gitconfig >>> gitconfig.backup"
fi

if [ -f ~/.gitignore_global ] ; then
    cat ~/.gitignore_global > ~/gitignore_global.backup
    rm -f ~/.gitignore_global
    echo "Existing .gitignore_global >>> gitignore_global.backup"
fi

if [ -f ~/.config/terminator/config ] ; then
    cat ~/.config/terminator/config > ~/.config/terminator/config.backup
    rm -rf ~/.config/terminator
    echo "Existing .config terminator >>> ~/.config/terminator/config.backup"
fi

ln -s $CURRENT/gitconfig ~/.gitconfig
ln -s $CURRENT/gitignore_global ~/.gitignore_global
ln -s $CURRENT/_config/terminator ~/.config/terminator
