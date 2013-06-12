#/bin/sh
PACKAGE = 'curl'

sudo apt-get install $PACKAGE

# Install composer.phar
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin

cd /usr/local/bin
# Create symlink for composer because a plugin oh-my-zsh 'composer' use "composer" for an alias
ln -s composer.phar composer
