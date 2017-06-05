.PHONY: init install-chruby
.DEFAULT_GOAL = init

init:
	@[ -d $$(readlink --canonicalize --no-newline ~/bin) ] || mkdir --parents ~/bin || exit 1
	@[ -e $$(readlink --canonicalize --no-newline ~/bin/mr) ] || ( \
	cd $(HOME)/bin && \
	  git clone --depth 1 git://myrepos.branchable.com/ myrepos && \
	  mv myrepos/mr . && rm -rf myrepos && chmod +x mr) || exit 1
	@git --version 1>/dev/null && ([ -d $$(shell readlink --canonicalize --no-newline ./repos/homeshick) ] || git clone --depth 1 https://github.com/andsens/homeshick.git ./repos/homeshick) || exit 1
	@[ -e $$(readlink --canonicalize --no-newline ~/.mrconfig) ] || echo >> ~/.mrconfig
	@grep --quiet \.homesick ~/.mrconfig || (\
	echo "[$(HOME)/.homesick]" >> ~/.mrconfig;\
	echo "checkout = git clone --depth 1 'git@github.com:dotfile-castle/.homesick.git' '.homesick'" >> ~/.mrconfig;\
	echo 'chain = true' >> ~/.mrconfig)
	@echo '~/.homesick/.mrconfig' >> ~/.mrtrust
	@$(HOME)/bin/mr checkout
	@mkdir -p ~/.fonts && cd ~/.fonts;\
	curl -LO https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf;\
	curl -LO https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf;\
	which fc-cache &> /dev/null && fc-cache -vf ~/.fonts/ || echo 'fc-cache not found'
	@mkdir -p ~/.vim/autoload/
	@ln -s ~/.homesick/repos/vim/home/.vim/autoload/plug.vim ~/.vim/autoload/plug.vim
	@vim +PlugInstall +qall

install-ruby:
	@sudo dnf install --assumeyes gcc automake bison zlib-devel libyaml-devel openssl-devel gdbm-devel readline-devel ncurses-devel libffi-devel
#	# @sudo apt-get install -y build-essential bison zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev
	@git --version 1>/dev/null && git clone --depth 1 https://github.com/postmodern/ruby-install.git /tmp/ruby-install || exit 1
	@sudo make --directory=/tmp/ruby-install install
	@rm --recursive --force /tmp/ruby-install
	@git --version 1>/dev/null && git clone --depth 1 https://github.com/postmodern/chruby.git /tmp/chruby || exit 1
	@sudo make --directory=/tmp/chruby install
	@rm --recursive --force /tmp/chruby
	@ruby-install ruby
