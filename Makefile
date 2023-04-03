ZSH_CUSTOM := $(HOME)/.oh-my-zsh/custom

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".DS_Store" -not -name ".gitkeep" -not -name ".gitmodules" -not -name ".travis.yml" -not -name ".oh-my-zsh" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;

.PHONY: vscode
vscode:
	ln -sfn $(CURDIR)/vscode/settings.json $$HOME/Library/Application\ Support/Code/User/settings.json
	ln -sfn $(CURDIR)/vscode/keybindings.json $$HOME/Library/Application\ Support/Code/User/keybindings.json
	ln -sfn $(CURDIR)/vscode/snippets $$HOME/Library/Application\ Support/Code/User/snippets
	bash $(CURDIR)/vscode/extensions 

.PHONY: vscode-ext-bump
vscode-ext-bump:
	@mv -v $(CURDIR)/vscode/extensions $(CURDIR)/vscode/extensions.old
	code --list-extensions | xargs -L 1 echo code --install-extension > $(CURDIR)/vscode/extensions

.PHONY: brewfile
brewfile:
	@mv -v $(CURDIR)/Brewfile $(CURDIR)/Brewfile.old
	@brew bundle dump

.PHONY: brew
brew:
	# /usr/bin/ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew bundle install --file "$(CURDIR)/Brewfile"
	sudo ln -sfn /opt/homebrew/bin/nvim /usr/local/bin/nvim
	sudo ln -sfn /opt/homebrew/bin/gpg /usr/local/bin/gpg
	sudo ln -sfn /opt/homebrew/bin/pinentry-mac /usr/local/bin/pinentry-mac

shell:
	if [ ! -d $$HOME/.oh-my-zsh ]; then \
		git clone https://github.com/robbyrussell/oh-my-zsh.git "$$HOME/.oh-my-zsh"; \
	else \
		cd "$$HOME/.oh-my-zsh"; \
		git pull "$$HOME/.oh-my-zsh"; \
	fi;

prompt: shell spaceship
spaceship:
	git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt"
	ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"

powerlevel9k:
	git clone https://github.com/bhilburn/powerlevel9k.git "${ZSH_CUSTOM}/themes/powerlevel9k"

.PHONY: asdf
asdf:
	asdf plugin-add java https://github.com/halcyon/asdf-java.git || true
	asdf plugin-add kubectl https://github.com/asdf-community/asdf-kubectl.git || true
	asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
	asdf plugin-add terraform https://github.com/asdf-community/asdf-hashicorp.git || true
	asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git || true

install-fzf:
	$$(brew --prefix)/opt/fzf/install
