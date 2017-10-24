#!/bin/bash

mkdir -p  ~/repos
cd ~/repos
git clone https://github.com/frutiger/git-vimdiff
cd ~/bin
ln -sf ~/repos/git-vimdiff/git-vimdiff.py git-vimdiff
