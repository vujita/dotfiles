#!/bin/sh
git config --unset commit.gpgsign
apt-get update -y && apt-get upgrade -y
apt install -y tmux exa vim ripgrep
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version

# Optional: exposing nvim globally.
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# Change shell
chsh -s /bin/zsh

sudo install lazygit /usr/local/bin
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

#zoxide
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | zsh

# install zap
mv ~/.zshrc ~/.zshrc_tmp
chmod +x zap/zap-install.zsh
zsh zap/zap-install.zsh --branch release-v1 --keep true
mv ~/.zshrc_tmp ~/.zshrc
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | zsh
./fonts/install.sh

chmod +x starship/starship-install.sh
sh starship/starship-install.sh --yes
