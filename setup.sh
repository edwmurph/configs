#!/bin/bash

# install git
which -s git 
if [[ $? != 0 ]] ; then
	printf "\nMANUALLY INSTALL GIT TO CONTINUE\n"
	return 1
fi

# symlink global gitignore
printf "\nSYMLINKING GLOBAL GITIGNORE:\n"
if [ -f ${HOME}/.gitignore ]; then
	read -p "local ~/.gitignore already found. Would you like to replace your local ~/.vimrc ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		return 1
	fi
fi
ln -fs ${HOME}/code/configs/dotfiles/gitignore ${HOME}/.gitignore
git config --global core.excludesfile ~/.gitignore


# install brew
which -s brew
if [[ $? != 0 ]] ; then
	printf "\nINSTALL HOMEBREW MANUALLY TO CONTINUE.\n"
	printf "https://brew.sh"
	return 1
else
	printf "\nUPDATING HOMEBREW:\n"
	brew update
fi


# install silver-searcher
which -s ag
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING SILVER_SEARCHER:\n"
	brew install the_silver_searcher
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
  brew cask install macdown
fi


# install vundle
if ! [ "$(ls -A ${HOME}/.vim/bundle/Vundle.vim)" ]; then
	printf "\nINSTALLING VUNDLE:\n"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi


# symlink vimrc
printf "\nSYMLINKING VIMRC:\n"
if [ -f ${HOME}/.vimrc ]; then
	read -p "local ~/.vimrc already found. Would you like to replace your local ~/.vimrc ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		return 1
	fi
fi
ln -s ${HOME}/code/personal/configs/dotfiles/vimrc ${HOME}/.vimrc

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
if [[ "$(which vim)" != '/usr/local/bin/vim' ]]; then
  brew install vim
fi

which -s kubectl
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING KUBECTL:\n"
	brew install kubectl
fi

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
		return 1
	fi
fi

mkdir ${HOME}/.aws
ln -s ${HOME}/.secrets/dotfiles/.aws ${HOME}

# install zsh syntax highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# install vim plug
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# add dir for vim swapfiles
mkdir -p ~/.vim/swapfiles

echo 
echo "finished"
