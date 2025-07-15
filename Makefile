install:
	./install.sh

update:
	git add .
	git commit -m "Update dotfiles"
	git push

sync:
	git pull
	./install.sh
