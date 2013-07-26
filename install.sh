#!/usr/bin/env bash

CURRENT=`pwd`
INSTALL_COMPOSER=true
INSTALL_ZSH=true
INSTALL_TERM=true

# Parsing options
if [ $# -gt 0 ] ; then
    for arg in $@ ; do
        if [ $arg = '--no-zsh' ] ; then
            INSTALL_ZSH=false
        elif [ $arg = '--no-composer' ] ; then
            INSTALL_VIM=false
        elif [ $arg = '--no-term' ] ; then
            INSTALL_TERM=false
        fi
    done
fi

PACKAGE='git git-core tig curl'

if $INSTALL_TERM ; then
    if [ -f ~/.config/terminator/config ] ; then
        cat ~/.config/terminator/config > ~/.config/terminator/config.backup
        rm -rf ~/.config/terminator
        echo "Existing .config terminator > save ~/.config/terminator/config.backup"
    fi

    ln -sf $CURRENT/_config/terminator/ ~/.config/terminator

    PACKAGE="$PACKAGE terminator"

    if [ -f ~/.config/terminator/config ] ; then
        cat ~/.config/terminator/config > ~/.config/terminator/config.backup
        rm -rf ~/.config/terminator
        echo "Existing .config terminator > save ~/.config/terminator/config.backup"
    fi

    ln -s $CURRENT/_config/terminator/ ~/.config/terminator
fi

echo "Installation des packages ------------------------- $PACKAGE"
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

if [ -f ~/.config/fontconfig ] ; then
    rm -rf ~/.config/fontconfig
    echo "Existing .config/fontconfig => remove"
fi


ln -sf $CURRENT/gitconfig ~/.gitconfig
ln -sf $CURRENT/gitignore_global ~/.gitignore_global
ln -sf $CURRENT/_config/fontconfig/ ~/.config/fontconfig
ln -sf $CURRENT/_fonts/ ~/.fonts

if $INSTALL_COMPOSER ; then
    echo "Installation de composer ------------------------- "
    ./lib/composer.sh
fi

git submodule update --init
if $INSTALL_ZSH ; then
    echo "Installation de zsh --------------------------- "
    cd $CURRENT/zsh-config
    ./install.sh
fi
