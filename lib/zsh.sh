#!/bin/sh

# Install zsh
sudo aptitude install zsh

# Change shell for zsh
chsh /bin/zsh

# Install oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Download zshrc
wget https://github.com/lesmyrmidons/dotfiles/.zshrc

# Move zshrc for current user
mv .zshrc ~/

