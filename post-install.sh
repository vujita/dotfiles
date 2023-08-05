#!/bin/zsh

fzf/install --all
nvm/install.sh
echo "Install node and source nvm"
source ~/.zshrc
NVM_DEFAULT_VERSION=18.6.0

nvm install $NVM_DEFAULT_VERSION
nvm alias default $NVM_DEFAULT_VERSION
# enableCorepackPnpm # from zsh_functions, setup corepack install of pnpm

TPM_FOLDER=~/.tmux/plugins/tpm
CURR=$PWD
if [ ! -d $TPM_FOLDER ]; then
	git clone https://github.com/tmux-plugins/tpm $TPM_FOLDER
else
	echo "Already exists"
fi

OS="$(uname)"
echo "$OS detected"
case $OS in
'Linux')
	echo "Linux"
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
		chmod u+x nvim.appimage
		./nvim.appimage --appimage-extract
		./squashfs-root/AppRun --version

		# Optional: exposing nvim globally.
		sudo mv squashfs-root /
		sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
    sudo apt install -y gcc g++ exa
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
	;;
'FreeBSD')
	echo "FreeBSD"
	;;
'WindowsNT')
	echo "Windows"
	;;
'Darwin')
	echo "Is Mac"
	./fonts/install.sh
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle
	chmod +x brew-update-deps.sh
	./brew-update-deps.sh
  pip3 install --user pynvim
	;;
'SunOS')
	echo "SunOS"
	;;
'AIX') ;;
*) ;;
esac
