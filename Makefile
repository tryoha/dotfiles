bootstrap:
	./bootstrap.sh

sync:
	nvim --headless "+Lazy! sync" +qa
	nvim --headless "+TSUpdateSync" +qa || true
