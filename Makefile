ZSH_CUSTOM := $$HOME/.oh-my-zsh/custom

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".DS_Store" -not -name ".gitkeep" -not -name ".gitmodules" -not -name ".travis.yml" -not -name ".oh-my-zsh" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	mkdir -p $(HOME)/.gnupg;
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

tpm: shell
	@if [ ! -d ~/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	else \
		echo "TPM already installed at ~/.tmux/plugins/tpm"; \
	fi

prompt: shell spaceship
spaceship:
	git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH_CUSTOM}/themes/spaceship-prompt"
	ln -s "${ZSH_CUSTOM}/themes/spaceship-prompt/spaceship.zsh-theme" "${ZSH_CUSTOM}/themes/spaceship.zsh-theme"

powerlevel9k:
	git clone https://github.com/bhilburn/powerlevel9k.git "${ZSH_CUSTOM}/themes/powerlevel9k"

.PHONY: asdf
asdf:
	asdf plugin add kubectl || true
	asdf plugin add nodejs || true
	asdf plugin add terraform || true
	asdf plugin add elixir || true
	asdf plugin add golang || true
	asdf plugin add rust || true

install-fzf:
	$$(brew --prefix)/opt/fzf/install

.PHONY: completions
completions:
	mkdir -p ${ZSH_CUSTOM}/completions
	wget "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/_kubectx.zsh"  -O "${ZSH_CUSTOM}/completions/_kubectx.zsh"
	wget "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/_kubens.zsh" -O "${ZSH_CUSTOM}/completions/_kubens.zsh"
