#!/usr/bin/env bash

PACKAGE='curl'

sudo apt-get install $PACKAGE

# Install composer.phar
echo "Install to composer.phar"
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin/

# Rename composer.phar composer
echo "Rename composer.phar composer"
sudo mv /usr/local/bin/composer.phar /usr/local/bin/composer
