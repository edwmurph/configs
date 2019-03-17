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


# install vundle
if ! [ "$(ls -A ${HOME}/.vim/bundle/Vundle.vim)" ]; then
	printf "\nINSTALLING VUNDLE:\n"
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi


# install fzf for fuzzy vim file search 
printf "\nINSTALLING FZF:\n"
brew install fzf
$(brew --prefix)/opt/fzf/install --completion --key-bindings --update-rc


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
ln -fs ${HOME}/code/configs/dotfiles/vimrc ${HOME}/.vimrc


# install nvm
which -s nvm
if [[ $? != 0 ]] ; then
	printf "\nINSTALLING NVM:\n"
	# following instructions from: https://github.com/edwmurph/nvm#git-install
	if ! [ -f "${HOME}/.nvm/nvm.sh" ]; then
		git clone https://github.com/edwmurph/nvm.git "${HOME}/.nvm"
	fi
	. "${HOME}/.nvm/nvm.sh"
fi


# install node
printf "\nINSTALLING NEWEST NODE.JS:\n"
nvm install node
nvm use node


# symlink bash_profile
printf "\nSYMLINKING BASH_PROFILE:\n"
if [[ -f ${HOME}/.bash_profile ]]; then
	read -p "local ~/.bash_profile already found. Would you like to replace your local ~/.bash_profile ? " -n 1 -r
	echo    # (optional) move to a new line
	if ! [[ $REPLY =~ ^[Yy]$ ]]; then
		echo "aborting script."
		return 1
	fi
fi
ln -fs ${HOME}/code/configs/dotfiles/bash_profile ${HOME}/.bash_profile
. ${HOME}/.bash_profile


# install python?
# brew install python3
# pip3 install --upgrade pip
# pip3 install jupyter
# pip3 install pandas
# pip3 install matplotlib


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

# TODO install mysql
# brew install mysql

# TODO install vim from brew instead of one shipped with OS
# brew install vim

# TODO install ctags
# brew install ctags
# add following to ~/.ctags
# --exclude=node_modules/*


echo 
echo "finished"
