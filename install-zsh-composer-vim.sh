#/usr/bin/sh

PACKAGE = 'git git-core curl zsh ruby vim php5 php5-cli python-markdown'

sudo apt-get install $PACKAGE

# Install composer.phar
curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin

# Install oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh

# Install config vim
git clone https://github.com/willdurand/vim-config.git
cd vim-config/
./install.sh

# Install markdown for vim
wget http://pypi.python.org/packages/source/M/Markdown/Markdown-2.0.tar.gz
tar xvzf Markdown-2.0.tar.gz
cd Markdown-2.0/
sudo python setup.py install
