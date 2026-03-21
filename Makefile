.PHONY: install uninstall update bench doctor lint test menu chezmoi-install chezmoi-init chezmoi-apply

install:
	@./install.sh

uninstall:
	@./install.sh --uninstall

update:
	@git pull --ff-only && source ~/.zshrc && echo "Updated."

lint:
	@echo "Checking zsh syntax..."
	@for f in zsh/.zshenv zsh/zshrc zsh/config/*.zsh; do \
		zsh -n "$$f" && echo "  [ok] $$f" || echo "  [FAIL] $$f"; \
	done

test:
	@if [ -n "$(TEST)" ]; then set -- $(TEST); zsh ./test/zsh_test.sh "$$@"; else zsh ./test/zsh_test.sh; fi

bench:
	@echo "Measuring shell startup time (5 runs)..."
	@for i in 1 2 3 4 5; do time zsh -i -c exit; done

doctor:
	@./install.sh --doctor

menu:
	@./install.sh --menu

chezmoi-install:
	@sh -c "$$(curl -fsLS get.chezmoi.io)" -- -b "$(HOME)/.local/bin"

chezmoi-init:
	@~/.local/bin/chezmoi init --apply thanhd/dotfiles

chezmoi-apply:
	@~/.local/bin/chezmoi apply -v
