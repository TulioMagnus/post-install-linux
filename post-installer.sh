#!/bin/bash
APT_PACKAGES=(fd-find ripgrep libtool-bin cmake tidy python3-pip snapd sqlite3 libsqlite3-dev neovim xclip git curl libssl-dev libreadline-dev zlib1g-dev autoconf bison build-essential libyaml-dev libreadline-dev libncurses5-dev libffi-dev libgdbm-dev)
NPM_PACKAGES=(vscode-css-languageserver-bin vscode-html-languageserver-bin typescript-language-server @tailwindcss/language-server@0.0.4 stylelint js-beautify import-js neovim diagnostic-languageserver)
SNAP_SOFTWARE=(slack postman dbeaver-ce libreoffice vlc docker discord gifex)
GITHUB_DOTFILES_REPOSITORY=git@github.com:TulioMagnus/dotfiles.git
RUBY_VERSIONS=(2.7.1 2.7.3 3.1.1 3.0.3)
GEMS=(solargraph neovim bundler)
export LAZY_VER="0.31.4" # LAZYGIT VERSION

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

# function to install Configuration and Dotfiles
install_dotfiles () {
echo "================= INSTALANDO DOTFILES ================="
  mkdir git/dotfiles
  cd ~/git/dotfiles; git reset --quiet --hard HEAD; git pull; cd
  git clone --quiet $GITHUB_DOTFILES_REPOSITORY ~/git/dotfiles
  # Creates virtual connection of dotfiles
  ln -s ~/git/dotfiles/zshrc ~/.zshrc
}

install_fonts () {
echo "================= INSTALANDO FONTES ================="
  sudo rm -r ~/.fonts
  mkdir ~/.fonts
  wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
  unzip -q -o JetBrainsMono.zip -d ./fonts
}

install_snap_common () {
  for i in $SNAP_SOFTWARE; do sudo snap install $i; done
}

install_emacs () {
echo "================= INSTALANDO EMACS ================="
  # Remove emacs and all it's dependencies to solve any kind of conflict
  sudo snap remove emacs
  sudo rm -r ~/snap/emacs
  sudo rm -r ~/.emacs.d
  sudo rm -r ~/.doom.d
  # Install Emacs using snap
  sudo snap install emacs --classic
  # Clone DOOM EMACS repositories
  git clone --quiet --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
  git clone --quiet https://github.com/otavioschwanck/doom_emacs_dotfiles.git ~/.doom.d
  ~/.emacs.d/bin/doom sync
}

install_nvim () {
echo "================= INSTALANDO NVIM ================="
  # Remove nvim and all it's dependencies to solve any kind of conflict
  sudo rm -r ~/.config/nvim
  # Install nvim using python3
  python3 -m pip install neovim-remote pynvim --quiet
  # Clone NVIM respositories
  git clone --quiet git@github.com:otavioschwanck/mood-nvim.git ~/.config/nvim
  cd ~/.config/nvim; git reset --quiet --hard HEAD; git pull; cd
  git config --global push.default current
  git clone --quiet --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  cd ~/.local/share/nvim/site/pack/packer/start/packer.nvim; git reset --quiet --hard HEAD; git pull; cd
}

install_gems () {
echo "================= INSTALANDO GEMS ================="
  for i in $GEMS; do gem install i --silent; done
}

install_lazygit () {
echo "================= INSTALANDO LAZY GIT ================="
  wget -q -O lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v${LAZY_VER}/lazygit_${LAZY_VER}_Linux_x86_64.tar.gz
  tar xf lazygit.tgz
  sudo mv lazygit /usr/local/bin/
}

# STEPS : Remove any step if not necessary
install_packages
install_dotfiles
install_snap_common
install_ruby
install_fonts
install_nvim
install_gems
install_lazygit
install_emacs

echo "Script finalizado!"
