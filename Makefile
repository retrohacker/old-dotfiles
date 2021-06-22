PORTS=/usr/ports
MARKER=.install

.PHONY: install
install:
	stow -v -t "${HOME}" home
