#!/bin/bash

. ~/.secrets/secrets.zsh

# ssh-copy-id ubuntu@$RPI_5

for PI in RPI_1 RPI_2 RPI_3 RPI_4; do
	IP="${!PI}"
	echo "copying files to $PI @ $IP..."
	scp dotfiles/rpi-profile ubuntu@$IP:~/.bash_profile
	scp dotfiles/rpi-vimrc ubuntu@$IP:~/.vimrc
done

echo 'done!'
