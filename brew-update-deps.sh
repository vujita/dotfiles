#!/bin/zsh

echo "Regenerate Brewfile"
rm Brewfile Brewfile.lock.json
brew bundle dump
brew bundle
brew cleanup
