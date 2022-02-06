#!/bin/bash

. ~/.secrets/secrets.zsh

for PI in RPI_1 RPI_2 RPI_3; do
	IP="${!PI}"
	echo "copying files to $PI @ $IP..."
	scp dotfiles/rpi-profile ubuntu@$IP:~/.bash_profile
	scp dotfiles/vimrc ubuntu@$IP:~/.vimrc
done

echo 'done!'
