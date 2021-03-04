#!/bin/bash

echo "Installing dotfiles"

" Check that all of our submodules work has been published before pushing the superproject
echo "Initializing submodule(s)"
git submodule update --init --recursive

source install/link.sh

if [ "$(uname)" == "Darwin" ]; then
    echo "Running on OSX"

    echo "Brewing all the things"
    source install/brew.sh

    echo "Updating OSX settings"
    source install/osx.sh
fi

echo "creating vim directories"
mkdir -p ~/.vim-tmp


echo "Configuring zsh as default shell"
chsh -s $(which zsh)

echo "Done."
