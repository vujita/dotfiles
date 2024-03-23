#!/bin/zsh

echo "Run brew bundle"
brew bundle install

echo "Regenerate Brewfile"
rm Brewfile Brewfile.lock.json
brew bundle dump
brew bundle
brew cleanup
