#!/bin/zsh

echo "Regenerate Brewfile"
brew bundle dump
brew bundle
brew cleanup
