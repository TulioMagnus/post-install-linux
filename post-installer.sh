#!/bin/bash
APT_PACKAGES=(fd-find ripgrep libtool-bin cmake tidy python3-pip snapd sqlite3 libsqlite3-dev neovim xclip git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev)
NPM_PACKAGES=(vscode-css-languageserver-bin vscode-html-languageserver-bin typescript-language-server @tailwindcss/language-server@0.0.4 stylelint js-beautify import-js neovim diagnostic-languageserver)
SNAP_SOFTWARE=(slack postman dbeaver-ce libreoffice vlc docker discord gifex)
GITHUB_DOTFILES_REPOSITORY=git@github.com:TulioMagnus/dotfiles.git
RUBY_VERSIONS=(2.7.1 2.7.3 3.1.1 3.0.3)

# Install base packages
install_packages () {
  echo "================= INSTALANDO PACOTES ================="
  sudo apt-get -qq update
  sudo apt-get -qq install ${APT_PACKAGES[*]} -y
  sudo npm install -s -g ${NPM_PACKAGES[*]} -y
}

install_ruby () {
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
  git clone https://github.com/rbenv/ruby-build.git
  cat ruby-build/install.sh
  PREFIX=/usr/local sudo ./ruby-build/install.sh
  echo "gem: --no-document" > ~/.gemrc
  for i in $RUBY_VERSIONS; do rbenv install $i -s; done
}

install_zsh() {
  # Oh My zsh plugin
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

# function to install Configuration and Dotfiles
install_dotfiles () {
echo "================= INSTALANDO DOTFILES ================="
  mkdir git/dotfiles
  cd ~/git/dotfiles; git reset --quiet --hard HEAD; git pull; cd
  git clone --quiet $GITHUB_DOTFILES_REPOSITORY ~/git/dotfiles
  # Creates virtual connection of dotfiles
  ln -s ~/git/dotfiles/zshrc ~/.zshrc
}

install_snap_common () {
  for i in $SNAP_SOFTWARE; do sudo snap install $i; done
}

# STEPS : Remove any step if not necessary
install_packages
install_zsh
install_dotfiles
install_snap_common
install_ruby

echo "Script finalizado!"
