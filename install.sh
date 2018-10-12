#!/usr/bin/env bash

CURRENT=`pwd`
BACKUP=$CURRENT/backup
INSTALL_COMPOSER=true
INSTALL_COMPOSER_GLOBAL=true
INSTALL_ZSH=true
INSTALL_TERM=true
INSTALL_ANSIBLE=false

# Parsing options
if [ $# -gt 0 ] ; then
    for arg in $@ ; do
        if [ $arg = '--no-zsh' ] ; then
            INSTALL_ZSH=false
        elif [ $arg = '--no-composer' ] ; then
            INSTALL_COMPOSER=false
        elif [ $arg = '--no-term' ] ; then
            INSTALL_TERM=false
        elif [ $arg = '--ansible' ] ; then
            INSTALL_ANSIBLE=true
        elif [ $arg = '--help' ] ; then
            printf "\033[0;32mDotfiles lesmyrmidons\033[0m\n\n"
            printf "\033[0;33mUsage:\033[0m\n"
            printf "  ./install.h [options]\n\n"
            printf "\033[0;33mOptions:\033[0m\n"
            printf "  \033[0;32m--no-zsh\033[0m\t\tDon't install zsh\n"
            printf "  \033[0;32m--no-composer\033[0m\t\tDon't install composer\n"
            printf "  \033[0;32m--no-term\033[0m\t\tDon't install term terminator\n"
            printf "  \033[0;32m--ansible\033[0m\t\tInstall ansible and a configuration\n"
            printf "  \033[0;32m--help\033[0m\t\tDisplay this help message\n"
            exit 0;
        fi
    done
fi

# Detect the platform (similar to $OSTYPE)
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

backup_file() {
    if [ -f $1/$2 ] ; then
        cat $1/$2 > $BACKUP/$2.backup
        printf "\033[0;36mExisting .config terminator > save\033[0m \033[0;32m$BACKUP/$2.backup\033[0m\n"
    fi
}

OS=`lowercase \`uname\``
case $OS in
  'linux')
     OS='Linux'
     ;;
  'darwin')
     OS='Mac'
     INSTALL_TERM=false
     which -s brew
     if [[ $? != 0 ]] ; then
         sudo chown -R $(whoami) /usr/local
         /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
     fi
     brew doctor
     ;;
  *) ;;
esac

mkdir -p $BACKUP

PACKAGE='git tig curl'

if $INSTALL_TERM ; then
    backup_file '~/.config/terminator/' 'config'
    rm -rf ~/.config/terminator
    ln -sf $CURRENT/_config/terminator/ ~/.config/terminator

    PACKAGE="$PACKAGE terminator"
fi

if $INSTALL_ANSIBLE ; then
    backup_file '~/' 'ansible.cfg'
    rm -f ~/.ansible.cfg
    ln -sf $CURRENT/ansible.cfg ~/.ansible.cfg
fi

printf "Install package ------------------------- \033[0;32m$PACKAGE\033[0m\n"
if [ "$OS" = "Mac" ] ; then
    brew update
    brew upgrade
    brew install $PACKAGE
else
    if [ "$OS" = "Linux" ] ; then
        sudo apt-get update
        sudo apt-get install $PACKAGE
    fi
fi
echo ""
printf "Test files exist ------------------------ \033[0;32m~/.gitconfig ~/.gitignore_global ~/.config/fontconfig\033[0m\n"

backup_file '~/' '.gitconfig'
rm -f ~/.gitconfig

backup_file '~/' '.gitignore_global'
rm -f ~/.gitignore_global

if [ "$OS" = "Linux" ] ; then
    if [ -f ~/.config/fontconfig ] ; then
        rm -rf ~/.config/fontconfig
        printf "   \033[0;36mExisting .config/fontconfig\033[0m \033[0;33m=> remove\033[0m\n"
    fi
    printf "   \033[0;36m.config/fontconfig\033[0m\n"
    ln -sf $CURRENT/_config/fontconfig/ ~/.config/fontconfig
    printf "   \033[0;36m.fonts\033[0m\n"
    ln -sf $CURRENT/_fonts/ ~/.fonts
    echo ""
    printf "Load fonts:\n"
    fc-cache -vf ~/.fonts
    echo ""
fi

printf "Create symlinks:\n"
printf "   \033[0;36m.gitconfig\033[0m\n"
ln -sf $CURRENT/gitconfig ~/.gitconfig
printf "   \033[0;36m.gitignore_global\033[0m\n"
ln -sf $CURRENT/gitignore_global ~/.gitignore_global
echo ""

echo "Installation de RVM ----------------------------- "
curl -L https://get.rvm.io | bash -s stable --auto-dotfiles --autolibs=enable
type rvm | head -1
rvm install 2.5.1
rvm use 2.5.1 --default

if $INSTALL_COMPOSER ; then
    echo "Installation de composer ------------------------- "
    lib/composer.sh global=$INSTALL_COMPOSER_GLOBAL
    
    if $INSTALL_ZSH ; then
        echo "Installation de zsh --------------------------- "
        $CURRENT/vendor/lesmyrmidons/zsh-config/install.sh
    fi
fi

if [ "$OS" = "Mac" ] ; then
    brew doctor
    sudo chown root:wheel /usr/local
fi

echo "End"

exit 0;
