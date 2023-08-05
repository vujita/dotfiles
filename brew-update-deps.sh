#!/bin/zsh

#echo "Run brew bundle"
#brew bundle

echo "Regenerate Brewfile"
rm Brewfile
brew bundle dump
brew bundle
brew cleanup
