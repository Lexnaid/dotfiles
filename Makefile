install:
	@if [ ! -f .env ]; then \
		echo "⚠️  .env file not found. Copying .env.example..."; \
		cp .env.example .env; \
		echo "📝 Please edit .env with your actual values before running install"; \
		exit 1; \
	fi
	./install.sh

setup-env:
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "✅ Created .env from template. Please edit it with your values."; \
	else \
		echo "⚠️  .env already exists"; \
	fi

update:
	git add .
	git commit -m "Update dotfiles"
	git push

sync:
	git pull
	./install.sh

clean-secrets:
	@echo "🧹 Removing sensitive files from git history..."
	git filter-branch --force --index-filter \
		'git rm --cached --ignore-unmatch gh/hosts.yml github-copilot/apps.json' \
		--prune-empty --tag-name-filter cat -- --all
	@echo "⚠️  Run 'git push --force' to update remote repository"
