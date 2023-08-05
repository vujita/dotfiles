#!/bin/zsh

if [ -z $CODESPACES ]; then
	echo "Is not in CODESPACES"
	chmod +x post-install.sh
	./post-install.sh
else
	echo "Is in CODESPACES"
  git config --unset commit.gpgsign
  zsh -c "curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh"
  export ZPLUG_HOME=~/.zplug
  rm -rf $ZPLUG_HOME
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
  apt-get update -y && apt-get upgrade -y
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  ./squashfs-root/AppRun --version

  # Optional: exposing nvim globally.
  sudo mv squashfs-root /
  sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
fi
