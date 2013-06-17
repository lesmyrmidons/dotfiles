#!/usr/bin/env bash

CURRENT=`pwd`
INSTALL_COMPOSER=true
INSTALL_ZSH=true

# Parsing options
if [ $# -gt 0 ] ; then
    for arg in $@ ; do
        if [ $arg = '--no-zsh' ] ; then
            INSTALL_ZSH=false
        elif [ $arg = '--no-composer' ] ; then
            INSTALL_VIM=false
        fi
    done
fi

PACKAGE='git git-core curl terminator'

sudo apt-get install $PACKAGE

if [ -f ~/.gitconfig ] ; then
    cat ~/.gitconfig > ~/gitconfig.backup
    rm -f ~/.gitconfig
    echo "Existing .gitconfig > save gitconfig.backup"
fi

if [ -f ~/.gitignore_global ] ; then
    cat ~/.gitignore_global > ~/gitignore_global.backup
    rm -f ~/.gitignore_global
    echo "Existing .gitignore_global > save gitignore_global.backup"
fi

if [ -f ~/.config/terminator/config ] ; then
    cat ~/.config/terminator/config > ~/.config/terminator/config.backup
    rm -rf ~/.config/terminator
    echo "Existing .config terminator > save ~/.config/terminator/config.backup"
fi

ln -s $CURRENT/gitconfig ~/.gitconfig
ln -s $CURRENT/gitignore_global ~/.gitignore_global
ln -s $CURRENT/_config/terminator/ ~/.config/terminator

if $INSTALL_COMPOSER ; then
    ./lib/composer.sh
fi
