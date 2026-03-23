# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A macOS dotfiles repo. Files are symlinked into `$HOME` via `make dotfiles`. This is not a build-and-test project; there is no CI, no test suite, and no compiled artifacts.

## Key Commands

```bash
make dotfiles     # Symlink all dotfiles into $HOME (skips .git, .gitignore, .DS_Store, etc.)
make brew         # Install Homebrew packages from Brewfile
make brewfile     # Regenerate Brewfile from currently installed packages
make vscode       # Symlink VS Code settings, keybindings, and snippets; install extensions
make vscode-ext-bump  # Snapshot current VS Code extensions list
make shell        # Install/update oh-my-zsh
make tpm          # Install tmux plugin manager
make completions  # Fetch kubectx/kubens zsh completions
```

## Architecture

**Shell setup chain** (load order matters):
`.zshrc` → oh-my-zsh (plugins: gcloud, brew, dotenv, virtualenv, uv) → `.exports` → `.aliases` → `.functions` → `.functions-work` (optional, work-specific)

**Symlink strategy**: `make dotfiles` finds all `.*` files at the repo root (excluding `.git`, `.gitignore`, `.DS_Store`, swap files) and symlinks them into `$HOME`. The `.gnupg/` directory is handled separately (individual file symlinks, not the whole dir). The `.config/` directory is NOT symlinked by the Makefile; those files are tracked but managed differently.

**Git config**: Commits are GPG-signed via 1Password SSH agent. Conditional includes (`includeIf`) swap. GitLab HTTPS URLs are auto-rewritten to SSH.

**tmux**: Prefix is `C-a` (not `C-b`). Vi keybindings. Uses TPM for plugins. Status bar shows kube context via `kube-tmux` plugin. Session switching via `C-j` with fzf popup.

**Version management**: Uses asdf (`.tool-versions`) for kubectl, nodejs, terraform, elixir, golang, rust. Also has nvm for Node.js.

## When Editing

- Dotfiles are symlinked, so edits here take effect in `$HOME` immediately (no re-run needed unless adding new files).
- Adding a new dotfile requires re-running `make dotfiles` to create the symlink.
- The `.config/` subdirectory contains app configs (alacritty, gh, glab, starship, fish, ghostty, gitui) that are tracked but not auto-symlinked.
- `.functions-work` contains work-specific shell functions; it is gitignored and optional.
