# Mis Dotfiles

Configuraciones personales para desarrollo.

## Contenido

- **nvim/**: Configuración de Neovim (con lazy.nvim y plugins)
- **tmux/**: Configuración de Tmux (formato XDG)
- **git/**: Configuración de Git
- **starship/**: Configuración de Starship prompt
- **github-copilot/**: Configuración de GitHub Copilot
- **gh/**: Configuración de GitHub CLI

## Instalación

```bash
git clone https://github.com/tuusuario/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

## Programas requeridos

- [Neovim](https://neovim.io/)
- [Tmux](https://github.com/tmux/tmux)
- [Git](https://git-scm.com/)
- [Starship](https://starship.rs/)
- [GitHub CLI](https://cli.github.com/)
- [GitHub Copilot](https://github.com/features/copilot)

## Compatibilidad

Compatible con:
- WSL (Windows Subsystem for Linux)
- Linux (Ubuntu, Arch, etc.)
- macOS

## GitHub Copilot

Para configurar GitHub Copilot en Neovim, agrega esto a tu `init.lua`:

```lua
-- Instalar vim-plug si no existe
local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')
Plug 'github/copilot.vim'
vim.call('plug#end')
```

Luego ejecuta `:PlugInstall` y `:Copilot setup` en Neovim.


# Securing Dotfiles with Environment Variables

## Current Security Issues

Your repository contains exposed OAuth tokens in:
- `gh/hosts.yml` - GitHub CLI OAuth token
- `github-copilot/apps.json` - GitHub Copilot OAuth token

## Solution: Environment Variables + Template Files

### Step 1: Create Template Files

Replace sensitive files with template versions:

**Create `gh/hosts.yml.template`:**
```yaml
github.com:
    users:
        ${GITHUB_USERNAME}:
            oauth_token: ${GITHUB_OAUTH_TOKEN}
    git_protocol: https
    user: ${GITHUB_USERNAME}
    oauth_token: ${GITHUB_OAUTH_TOKEN}
```

**Create `github-copilot/apps.json.template`:**
```json
{
    "github.com:Iv1.b507a08c87ecfe98": {
        "user": "${GITHUB_USERNAME}",
        "oauth_token": "${GITHUB_COPILOT_TOKEN}",
        "githubAppId": "Iv1.b507a08c87ecfe98"
    }
}
```

### Step 2: Update .gitignore

Add these lines to your `.gitignore`:
```gitignore
# Sensitive configuration files
gh/hosts.yml
github-copilot/apps.json

# Environment files
.env
.env.local
.env.*.local

# Backup files
*.backup.*
```

### Step 3: Create Environment Setup

**Create `.env.example`:**
```bash
# GitHub Configuration
GITHUB_USERNAME=your_username_here
GITHUB_OAUTH_TOKEN=your_github_oauth_token_here
GITHUB_COPILOT_TOKEN=your_copilot_token_here

# Git Configuration
GIT_USER_NAME="Your Full Name"
GIT_USER_EMAIL="your.email@example.com"
```

**Create `.env` (for your local setup):**
```bash
# GitHub Configuration
GITHUB_USERNAME=Lexnaid
GITHUB_OAUTH_TOKEN=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
GITHUB_COPILOT_TOKEN=ghu_Yt37mVaQXgoVq1uDrlEuZAeD0Z71vX2C284R

# Git Configuration  
GIT_USER_NAME="Lexnaid"
GIT_USER_EMAIL="danielcantu000@gmail.com"
```

### Step 4: Update install.sh

Replace the relevant sections in your `install.sh`:

```bash
#!/bin/bash

# Load environment variables
if [[ -f "$DOTFILES_DIR/.env" ]]; then
    source "$DOTFILES_DIR/.env"
    echo -e "${GREEN}✓ Environment variables loaded${NC}"
else
    echo -e "${RED}✗ .env file not found. Copy .env.example to .env and configure it.${NC}"
    exit 1
fi

# Function to substitute environment variables in template files
substitute_env_vars() {
    local template_file="$1"
    local output_file="$2"
    
    if [[ -f "$template_file" ]]; then
        envsubst < "$template_file" > "$output_file"
        echo -e "${GREEN}✓ Generated: $output_file${NC}"
    else
        echo -e "${RED}✗ Template not found: $template_file${NC}"
    fi
}

# GitHub CLI configuration
echo -e "\n🐙 Configuring GitHub CLI..."
if [[ -d "$DOTFILES_DIR/gh" ]]; then
    backup_if_exists "$HOME/.config/gh"
    mkdir -p "$HOME/.config/gh"
    
    # Copy static config
    if [[ -f "$DOTFILES_DIR/gh/config.yml" ]]; then
        cp "$DOTFILES_DIR/gh/config.yml" "$HOME/.config/gh/"
    fi
    
    # Generate hosts.yml from template
    substitute_env_vars "$DOTFILES_DIR/gh/hosts.yml.template" "$HOME/.config/gh/hosts.yml"
    
    echo -e "${GREEN}✓ GitHub CLI configured with environment variables${NC}"
fi

# GitHub Copilot configuration  
echo -e "\n🤖 Configuring GitHub Copilot..."
if [[ -d "$DOTFILES_DIR/github-copilot" ]]; then
    backup_if_exists "$HOME/.config/github-copilot"
    mkdir -p "$HOME/.config/github-copilot"
    
    # Copy versions.json (not sensitive)
    if [[ -f "$DOTFILES_DIR/github-copilot/versions.json" ]]; then
        cp "$DOTFILES_DIR/github-copilot/versions.json" "$HOME/.config/github-copilot/"
    fi
    
    # Generate apps.json from template
    substitute_env_vars "$DOTFILES_DIR/github-copilot/apps.json.template" "$HOME/.config/github-copilot/apps.json"
    
    echo -e "${GREEN}✓ GitHub Copilot configured with environment variables${NC}"
fi

# Git configuration with environment variables
echo -e "\n🌿 Configuring Git..."
if [[ -f "$DOTFILES_DIR/git/.gitconfig.template" ]]; then
    substitute_env_vars "$DOTFILES_DIR/git/.gitconfig.template" "$HOME/.gitconfig"
else
    # Fallback to existing .gitconfig
    create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
fi
```

### Step 5: Create Git Template (Optional)

**Create `git/.gitconfig.template`:**
```ini
[user]
	name = ${GIT_USER_NAME}
	email = ${GIT_USER_EMAIL}
[credential]
	helper = manager
	credentialStore = secretservice
[credential "https://github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential
[credential "https://gist.github.com"]
	helper = 
	helper = !/usr/bin/gh auth git-credential
```

### Step 6: Update Makefile

Add environment setup to your Makefile:

```makefile
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
```

### Step 7: Update README.md

Add to your README.md:

```markdown
## Initial Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. Set up environment variables:
   ```bash
   make setup-env
   # Edit .env with your actual values
   nano .env
   ```

3. Install dotfiles:
   ```bash
   make install
   ```

## Environment Variables

Copy `.env.example` to `.env` and configure:

- `GITHUB_USERNAME`: Your GitHub username
- `GITHUB_OAUTH_TOKEN`: GitHub personal access token
- `GITHUB_COPILOT_TOKEN`: GitHub Copilot token
- `GIT_USER_NAME`: Your full name for git commits
- `GIT_USER_EMAIL`: Your email for git commits

**Important**: Never commit the `.env` file to version control.
```

## Immediate Actions Needed

1. **Remove sensitive files from git history:**
   ```bash
   git rm gh/hosts.yml github-copilot/apps.json
   git commit -m "Remove sensitive files"
   ```

2. **Add template files:**
   ```bash
   # Create the template files as shown above
   git add gh/hosts.yml.template github-copilot/apps.json.template .env.example .gitignore
   git commit -m "Add environment variable templates"
   ```

3. **Set up local environment:**
   ```bash
   make setup-env
   # Edit .env with your actual tokens
   ```

4. **Test the installation:**
   ```bash
   make install
   ```

This approach ensures your sensitive tokens are never committed to git while maintaining the functionality of your dotfiles across different machines.



