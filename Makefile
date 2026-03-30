ZSH_CUSTOM := $$HOME/.oh-my-zsh/custom
BREWFILE    := $(CURDIR)/Brewfile

.PHONY: help
help: ## Show available targets.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: dotfiles
dotfiles: ## Symlink all dotfiles into $HOME.
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".DS_Store" -not -name ".gitkeep" -not -name ".gitmodules" -not -name ".travis.yml" -not -name ".oh-my-zsh" -not -name ".gitignore" -not -name ".git" -not -name ".*.swp" -not -name ".gnupg"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done; \
	mkdir -p $(HOME)/.gnupg;
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	mkdir -p $(HOME)/.claude;
	ln -sfn $(CURDIR)/.claude/settings.json $(HOME)/.claude/settings.json;
	ln -sfn $(CURDIR)/.claude/notify.py $(HOME)/.claude/notify.py;

.PHONY: brew
brew: ## Install Homebrew packages from the curated Brewfile.
	brew bundle install --file "$(CURDIR)/Brewfile"
	sudo ln -sfn /opt/homebrew/bin/nvim /usr/local/bin/nvim
	sudo ln -sfn /opt/homebrew/bin/gpg /usr/local/bin/gpg
	sudo ln -sfn /opt/homebrew/bin/pinentry-mac /usr/local/bin/pinentry-mac

.PHONY: brew-cleanup
brew-cleanup: ## Install from Brewfile AND uninstall anything not in it. Run 'make brewfile' first.
	brew bundle install --cleanup --file "$(CURDIR)/Brewfile"
	sudo ln -sfn /opt/homebrew/bin/nvim /usr/local/bin/nvim
	sudo ln -sfn /opt/homebrew/bin/gpg /usr/local/bin/gpg
	sudo ln -sfn /opt/homebrew/bin/pinentry-mac /usr/local/bin/pinentry-mac

.PHONY: brewfile
brewfile: ## Show user-installed packages not yet tracked in the curated Brewfile.
	@echo "==> Untracked user-installed formulae (add these to the right group in Brewfile):"
	@comm -23 \
		<(brew leaves | sed 's|.*/||' | sort) \
		<(grep '^brew ' $(BREWFILE) | sed 's/brew "//;s/".*//' | awk -F'/' '{print $$NF}' | sort) \
		| sed 's/^/  /'
	@echo ""
	@echo "==> Untracked casks:"
	@comm -23 \
		<(brew list --cask | sort) \
		<(grep '^cask ' $(BREWFILE) | sed 's/cask "//;s/".*//' | sort) \
		| sed 's/^/  /'

.PHONY: brewfile-dump
brewfile-dump: ## Dump raw brew state to Brewfile.dump (does NOT overwrite the curated Brewfile).
	@brew bundle dump --file "$(CURDIR)/Brewfile.dump" --force
	@echo "Dumped to Brewfile.dump."

.PHONY: vscode
vscode: ## Symlink VS Code settings and install extensions.
	ln -sfn $(CURDIR)/vscode/settings.json $$HOME/Library/Application\ Support/Code/User/settings.json
	ln -sfn $(CURDIR)/vscode/keybindings.json $$HOME/Library/Application\ Support/Code/User/keybindings.json
	ln -sfn $(CURDIR)/vscode/snippets $$HOME/Library/Application\ Support/Code/User/snippets
	bash $(CURDIR)/vscode/extensions

.PHONY: vscode-ext-bump
vscode-ext-bump: ## Snapshot currently installed VS Code extensions.
	@mv -v $(CURDIR)/vscode/extensions $(CURDIR)/vscode/extensions.old
	code --list-extensions | xargs -L 1 echo code --install-extension > $(CURDIR)/vscode/extensions

.PHONY: shell
shell: ## Install or update oh-my-zsh.
	if [ ! -d $$HOME/.oh-my-zsh ]; then \
		git clone https://github.com/ohmyzsh/ohmyzsh.git "$$HOME/.oh-my-zsh"; \
	else \
		cd "$$HOME/.oh-my-zsh" && git pull; \
	fi;

.PHONY: tpm
tpm: shell ## Install tmux plugin manager.
	@if [ ! -d ~/.tmux/plugins/tpm ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	else \
		echo "TPM already installed at ~/.tmux/plugins/tpm"; \
	fi

.PHONY: asdf
asdf: ## Add asdf plugins for version-managed runtimes.
	asdf plugin add kubectl || true
	asdf plugin add nodejs || true
	asdf plugin add terraform || true
	asdf plugin add elixir || true
	asdf plugin add golang || true
	asdf plugin add rust || true

.PHONY: completions
completions: ## Fetch kubectx/kubens zsh completions.
	mkdir -p ${ZSH_CUSTOM}/completions
	wget "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/_kubectx.zsh" -O "${ZSH_CUSTOM}/completions/_kubectx.zsh"
	wget "https://raw.githubusercontent.com/ahmetb/kubectx/master/completion/_kubens.zsh" -O "${ZSH_CUSTOM}/completions/_kubens.zsh"
