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
            INSTALL_COMPOSER=false
        elif [ $arg = '--no-term' ] ; then
            INSTALL_TERM=false
        elif [ $arg = '--help' ] ; then
            printf "\033[0;32mDotfiles lesmyrmidons\033[0m\n\n"
            printf "\033[0;33mUsage:\033[0m\n"
            printf "  ./install.h [options]\n\n"
            printf "\033[0;33mOptions:\033[0m\n"
            printf "  \033[0;32m--no-zsh\033[0m\t\tDon't install zsh\n"
            printf "  \033[0;32m--no-composer\033[0m\t\tDon't install composer\n"
            printf "  \033[0;32m--no-term\033[0m\t\tDon't install term terminator\n"
            printf "  \033[0;32m--help\033[0m\t\tDisplay this help message\n"
            exit 0;
        fi
    done
fi

PACKAGE='git git-core tig curl'

if $INSTALL_TERM ; then
    if [ -f ~/.config/terminator/config ] ; then
        cat ~/.config/terminator/config > ~/.config/terminator/config.backup
        rm -rf ~/.config/terminator
        printf "\033[0;36mExisting .config terminator > save\033[0m \033[0;32m~/.config/terminator/config.backup\033[0m\n"
    fi

    ln -sf $CURRENT/_config/terminator/ ~/.config/terminator

    PACKAGE="$PACKAGE terminator"

    if [ -f ~/.config/terminator/config ] ; then
        cat ~/.config/terminator/config > ~/terminator-config.backup
        rm -rf ~/.config/terminator
        printf "\033[0;36mExisting .config terminator > save\033[0m \033[0;32m~/terminator-config.backup\033[0m\n"
    fi

    ln -s $CURRENT/_config/terminator/ ~/.config/terminator
fi

printf "Install package ------------------------- \033[0;32m$PACKAGE\033[0m\n"
sudo apt-get install $PACKAGE
echo ""
printf "Test files exist ------------------------ \033[0;32m~/.gitconfig ~/.gitignore_global ~/.config/fontconfig\033[0m\n"
if [ -f ~/.gitconfig ] ; then
    cat ~/.gitconfig > ~/gitconfig.backup
    rm -f ~/.gitconfig
    printf "   \033[0;36mExisting .gitconfig\t\t> save\033[0m \033[0;32mgitconfig.backup\033[0m\n"
fi

if [ -f ~/.gitignore_global ] ; then
    cat ~/.gitignore_global > ~/gitignore_global.backup
    rm -f ~/.gitignore_global
    printf "   \033[0;36mExisting .gitignore_global\t> save\033[0m \033[0;32mgitignore_global.backup\033[0m\n"
fi

if [ -f ~/.config/fontconfig ] ; then
    rm -rf ~/.config/fontconfig
    printf "   \033[0;36mExisting .config/fontconfig\033[0m \033[0;33m=> remove\033[0m\n"
fi

echo ""
printf "Create symlinks:\n"
printf "   \033[0;36m.gitconfig\033[0m\n"
ln -sf $CURRENT/gitconfig ~/.gitconfig
printf "   \033[0;36m.gitignore_global\033[0m\n"
ln -sf $CURRENT/gitignore_global ~/.gitignore_global
printf "   \033[0;36m.config/fontconfig\033[0m\n"
ln -sf $CURRENT/_config/fontconfig/ ~/.config/fontconfig
printf "   \033[0;36m.fonts\033[0m\n"
ln -sf $CURRENT/_fonts/ ~/.fonts

echo ""
printf "Load fonts:\n"
fc-cache -vf ~/.fonts
echo ""

if $INSTALL_COMPOSER ; then
    echo "Installation de composer ------------------------- "
    lib/composer.sh
fi

if $INSTALL_ZSH ; then
    git submodule update --init
    git submodule foreach git pull origin master
    echo "Installation de zsh --------------------------- "
    cd $CURRENT/zsh-config
    ./install.sh
fi
echo "End"
