#!/bin/bash

mkdir -p ~/repos
mkdir -p ~/bin
cd ~/repos
git clone https://github.com/frutiger/git-vimdiff
cd ~/bin
ln -s ~/repos/git-vimdiff/git-vimdiff.py git-vimdiff

echo "git-vimdiff needs to the EDITOR variable set so if you haven't already: echo 'export EDITOR=vim' >> ~/.bashrc && export EDITOR=vim"
