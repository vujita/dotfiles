#!/bin/zsh

export DEBIAN_FRONTEND=noninteractive
command_exists () {
  type "$1" &> /dev/null ;
}

if command_exists zap ; then
  echo "zap already installed"
else
  mv ~/.zshrc ~/.zshrc_tmp
  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
  mv ~/.zshrc_tmp ~/.zshrc
fi

curl -sS https://starship.rs/install.sh | sh
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
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
    ./fonts/install.sh
		curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
		chmod u+x nvim.appimage
		./nvim.appimage --appimage-extract
		./squashfs-root/AppRun --version

		# Optional: exposing nvim globally.
		sudo mv squashfs-root /
		sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
    sudo apt install -y gcc \
      g++ exa ripgrep \
      python3-pip xclip fd-find \
      vim tmux exa

    sudo pip3 install neovim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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
  if command_exists brew ; then
    echo "Brew already installed"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
	brew bundle
	chmod +x brew-update-deps.sh
	./brew-update-deps.sh
	;;
'SunOS')
	echo "SunOS"
	;;
'AIX') ;;
*) ;;
esac
