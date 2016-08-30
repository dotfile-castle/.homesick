.PHONY: init
.DEFAULT_GOAL = init

init:
	@[ -d $(shell readlink --canonicalize --no-newline ~/bin) ] || mkdir --parents ~/bin || exit 1
	@[ -e $(shell readlink --canonicalize --no-newline ~/bin/mr) ] || (cd $(HOME)/bin && curl --location --remote-name --silent --show-error https://github.com/joeyh/myrepos/raw/master/mr && chmod +x mr) || exit 1
	@git --version 1>/dev/null && ([ -d $(shell readlink --canonicalize --no-newline ./repos/homeshick) ] || git clone https://github.com/andsens/homeshick.git ./repos/homeshick) || exit 1
	@[ -e $(shell readlink --canonicalize --no-newline ~/.mrconfig) ] || echo >> ~/.mrconfig
	@grep --quiet \.homesick ~/.mrconfig || (\
	echo "[$(HOME)/.homesick]" >> ~/.mrconfig;\
	echo "checkout = git clone 'git@github.com:dotfile-castle/.homesick.git' '.homesick'" >> ~/.mrconfig;\
	echo 'chain = true' >> ~/.mrconfig)
	@$(HOME)/bin/mr bootstrap .mrconfig
