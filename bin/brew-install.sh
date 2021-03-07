#/bin/bash

PLATFORM='unknown'
UNAMESTR=`uname`
if [[ "$UNAMESTR" == 'Linux' ]]; then
   PLATFORM='linux'
elif [[ "$UNAMESTR" == 'Darwin' ]]; then
   PLATFORM='macos'
fi

echo $PLATFORM

# tmux
# https://github.com/tmux/tmux/wiki/Installing
if [[ $PLATFORM == 'linux' ]]; then
  apt-get install libevent-dev ncurses-dev build-essential bison pkg-config
brew install tmux --HEAD
# https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

# neovim
# https://github.com/neovim/neovim/wiki/Installing-Neovim
brew install neovim
# https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
nvim +PlugInstall

# custom taps
brew tap clementtsang/bottom
brew install bottom
brew tap federico-terzi/espanso
brew install espanso

# install dependencies
brew install bash
brew install bat
brew install fd
brew install fzf
brew install gh
brew install git
brew install git-delta
brew install lazydocker
brew install lazygit
brew install lf
brew install lsd
brew install neofetch
brew install pgcli
brew install ripgrep
brew install starship
brew install tealdeer
brew install wakatime-cli
brew install zoxide

if [[ $PLATFORM == 'macos' ]]; then
   brew install trash-cli

# skhd
if [[ $PLATFORM == 'macos' ]]; then
   brew install skhd
   brew services start skhd

# yabai
if [[ $PLATFORM == 'macos' ]]; then
   brew install yabai
   brew services start yabai

# fish
brew install fish
# https://github.com/jorgebucaran/fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install FabioAntunes/fish-nvm edc/bass

# nvm
brew install nvm
# https://github.com/nvm-sh/nvm
mkdir ~/.nvm
nvm install 'lts/*'

# casks
brew install --cask 1password
brew install --cask alacritty

if [[ $PLATFORM == 'macos' ]]; then
   brew install --cask alfred           
   brew install --cask discord          
   brew install --cask fantastical      
   brew install --cask home-assistant   
   brew install --cask obsidian         
   brew install --cask postman          
   brew install --cask raycast          
   brew install --cask rocket           
   brew install --cask slack
   brew install --cask spacelauncher    
   brew install --cask spotify
   brew install --cask vivaldi
