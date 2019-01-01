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

	