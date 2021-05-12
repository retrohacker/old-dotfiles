PORTS=/usr/ports
MARKER=.install

.PHONY: install
install:
	stow -v --dotfiles -t "${HOME}/.config" dot-config
