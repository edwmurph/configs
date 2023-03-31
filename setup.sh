#!/bin/bash

# install git
which -s git 
if [[ $? != 0 ]] ; then
	printf "\nMANUALLY INSTALL GIT TO CONTINUE\n"
	exit 1
fi

# symlink global gitignore
printf "\nSYMLINKING GLOBAL GITIGNORE:\n"
if [ -f ${HOME}/.gitignore ]; then
	read -p "local ~/.gitignore already found. Would you like to replace your local ~/.gitignore ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		exit 1
	fi
fi

# install brew
which -s brew
if [[ $? != 0 ]] ; then
	printf "\nINSTALL HOMEBREW MANUALLY TO CONTINUE.\n"
	printf "https://brew.sh"
	exit 1
else
	printf "\nUPDATING HOMEBREW:\n"
	brew update
fi

# install git stuff
brew install gpg2 gnupg pinentry-mac

ln -fs ${HOME}/.secrets/dotfiles/.gnupg ${HOME}/.gnupg
chmod 700 ~/.gnupg
git config --global push.default current
ln -fs ${HOME}/code/personal/configs/dotfiles/gitignore ${HOME}/.gitignore
git config --global core.excludesfile ~/.gitignore
git config --global gpg.program $(which gpg)
git config --global user.signingkey 60F96B0F
git config --global commit.gpgsign true

# install zsh stuff
ln -fs ${HOME}/code/personal/configs/dotfiles/zshrc ${HOME}/.zshrc
brew install zsh-history-substring-search

# install terraform stuff
brew install tfenv

# flux stuff
brew install fluxcd/tap/flux

# talos stuff
ln -fs ${HOME}/.secrets/dotfiles/.talos ${HOME}/.talos

# install nvim
which -s nvim
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING NVIM"
	brew install nvim
	mkdir -p ~/.config
	ln -fs ${HOME}/code/personal/configs/nvim ${HOME}/.config/nvim
fi

# install silver-searcher
which -s ag
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING SILVER_SEARCHER:\n"
	brew install the_silver_searcher
fi

# install fzf for fuzzy vim file search
which -s gawk
if [[ $? != 0 ]] ; then
  printf "\nINSTALLING GAWK:\n"
  brew install gawk
fi

# install fzf for fuzzy vim file search
which -s fzf
if [[ $? != 0 ]] ; then
  printf "\nINSTALLING FZF:\n"
  brew install fzf
  $(brew --prefix)/opt/fzf/install --completion --key-bindings --update-rc
fi


# install fzf for fuzzy vim file search
which -s macdown
if [[ $? != 0 ]] ; then
  printf "\nINSTALLING MACDOWN:\n"
  brew install --cask macdown
fi

# ln -fs ${HOME}/code/personal/configs/dotfiles/vimrc ${HOME}/.vimrc

# install fnm
which -s fnm
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING FNM:\n"
  brew install Schniz/tap/fnm
fi

# install tree
which -s tree
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING TREE:\n"
	brew install tree
fi

# install bat
which -s bat
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING BAT:\n"
	brew install bat
fi

# use vim from brew instead of one shipped with OS
# if [[ "$(which vim)" != '/usr/local/bin/vim' ]]; then
#   brew install vim
# fi

which -s kubectl
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING KUBECTL:\n"
	brew install kubectl
fi
ln -fs ${HOME}/.secrets/dotfiles/.kube ${HOME}/.kube

which -s jq
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING JQ:\n"
	brew install jq
fi

which -s curl
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING CURL:\n"
	brew install curl
fi

# symlink .aws
printf "\nSYMLINKING AWS CONFIG:\n"
if [ -d ${HOME}/.aws ]; then
	read -p "local ~/.aws already found. Would you like to replace your local ~/.aws ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		exit 1
	fi
fi

ln -fs ${HOME}/.secrets/dotfiles/.aws ${HOME}/.aws

# symlink .ssh
printf "\nSYMLINKING SSH CONFIG:\n"
if [ -d ${HOME}/.ssh ]; then
	read -p "local ~/.ssh already found. Would you like to replace your local ~/.ssh ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		exit 1
	fi
fi

ln -fs ${HOME}/.secrets/dotfiles/.ssh ${HOME}/.ssh

echo 
echo "finished"
