.PHONY: install uninstall update bench doctor lint

install:
	@./install.sh

uninstall:
	@./install.sh --uninstall

update:
	@git pull --ff-only && source ~/.zshrc && echo "Updated."

lint:
	@echo "Checking zsh syntax..."
	@for f in zsh/zshrc zsh/config/*.zsh; do \
		zsh -n "$$f" && echo "  [ok] $$f" || echo "  [FAIL] $$f"; \
	done

bench:
	@echo "Measuring shell startup time (5 runs)..."
	@for i in 1 2 3 4 5; do time zsh -i -c exit; done

doctor:
	@./install.sh --doctor
