# Freebsd

Handbook is in /usr/local/share/doc/freebsd/handbook

During install, include sources

Chapter 30.11 for configuring ntp, doesn't sync clock by default

# Setting up i3

`pkg install i3-gaps` to get all deps

Then `pkg remove i3-gaps` before doing the port install

Look at the `Makefile` in ports to see build time dependecies and install those

Then copy the patch file into `./files` and `make install clean`

If you want to make changes, copy the file out of `work`. Then:

`make clean extract; cp [file] ./work/i3-*/path/to/[file]; make reinstall`

# gnu stow

No notes, usage is straightforward if you read `man stow`. Makefile documents my use.

# Bash

The default interpreter for FreeBSD isn't bash. `pkg install bash bash-completion` and then `chpass` to update the shell to /usr/local/bin/bash

# FZF

`pkg install fzf`

# Kakoune

Install the language server by cloning and running `make build`. Then copy the language server binary to `/bin`.

To get gopls, run `GO11MODULE=ON go get golang.org/x/tools/gopls@latest`
