#!/usr/bin/env bash

PACKAGE='curl'
PWD=`pwd`

# Detect the platform (similar to $OSTYPE)
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

OS=`lowercase \`uname\``
case $OS in
  'linux')
     OS='Linux'
     ;;
  'darwin')
     OS='Mac'
     ;;
  *) ;;
esac

if [ "$OS" = "Mac" ] ; then
    brew install $PACKAGE
else
    sudo apt-get install $PACKAGE
fi

# Install composer.phar
echo "Install to composer.phar"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=../

if [ "$1" = false ] ; then
    cd .. && ./composer.phar install
else
    # Rename composer.phar composer
    echo "Rename composer.phar composer"
    mv $PWD/../composer.phar /usr/local/bin/composer
    cd $PWD/.. && composer install
fi

