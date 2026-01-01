#!/bin/zsh

echo "Regenerate Brewfile"
[ -f Brewfile ] && echo "remove Brewfile" && rm Brewfile
brew bundle dump
# brew bundle
brew cleanup
