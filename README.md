# WSL2 PHP Development Stack

A clean, fast installer for Debian and Ubuntu. It sets up a complete PHP development environment on WSL2 or a regular Linux machine. You get PHP-FPM, a web server, MariaDB, Redis, Node.js, Composer, and uv. The defaults are chosen to be safe for local development.

You can also bring your own private files, like custom domains, SSL certificates, and SSH keys. Those files stay on your machine. They are never pushed to Git.

## Quick Start

### 1. Interactive setup (recommended)

The easiest way to start. The installer asks what you want, saves your choices, and runs the setup.

```bash
git clone https://github.com/insanchen/wsl2php.git
cd wsl2php
./install.sh --configure
```

### 2. Automated setup

A good fit when you know exactly what you want, or when you are setting up a server.

```bash
cp .env.example .env
# Edit .env with your preferred text editor (e.g., nano .env)
chmod 600 .env

# Optional: preview what will be installed
./install.sh --dry-run --yes

# Run the installation automatically
./install.sh --yes
```

## What it sets up

With the default choices, you get:

| Component | Default |
|---|---|
| PHP | Versions 8.4 and 8.5, running as PHP-FPM |
| Web server | Nginx |
| Database | MariaDB, reachable from localhost only |
| Cache | Redis, running over a fast Unix socket |
| Dev tools | On (Node.js LTS, Composer, uv, jq, tmux, tree, and more) |
| phpMyAdmin | Off |
| Shell theme | Off (Oh My Zsh and Powerlevel10k) |

You can change any of these in `.env` or during the interactive setup.

A few pieces deserve a plain explanation. PHP-FPM is the part that runs your PHP code. The web server is a pick one choice, Nginx or Apache. They both want ports 80 and 443, so the installer asks you to choose one and turns the other off. Redis is a fast cache and store. It talks to PHP through a Unix socket, which is a quick local connection instead of a network port. Node.js is installed through nvm, a small version manager for your user account, at the LTS version, and npm is updated to the latest release. uv is a fast Python package installer. Composer is a tool that installs PHP packages. The installer checks Composer against its published checksum before running it.

## Configuration (.env)

The `.env` file controls the installation. A few rules matter:

- Choose one web server. Turn on Nginx or Apache, not both.
- Databases are optional. List names with `INSTALL_DB_NAMES="app1 app2"` and they are created for you. Leave the database fields blank and no databases are created.
- Database accounts only work from `localhost`. They cannot log in from other machines.

## Using private files (never pushed to Git)

Sensitive files like SSL certificates, SSH keys, and custom Nginx rules go in `config/private/`. Git ignores this folder completely.

```text
config/private/
├── ssl/        # Put your domain certs here (e.g., mysite.com.pem, mysite.com.key)
├── ssh/        # Put your SSH keys and config here
├── mysql/      # Custom MySQL settings (e.g., server.my.cnf)
├── nginx/      # Custom Nginx blocks
├── scripts/    # Custom bash scripts to run at the end (addons.sh, sshclone.sh)
├── bash_aliases # Your personal terminal shortcuts
└── backup/     # Configuration backup, restored on reinstall (opencode/, agents/)
```

If you run on `localhost` without private SSL certificates, the installer creates a self-signed certificate for you.

## Notes and security

- Safe execution. The installer stops right away if anything goes wrong. Before it finishes, it checks Nginx or Apache, PHP-FPM, MariaDB, and Redis to confirm they are healthy.
- php.ini safety. On servers that are not localhost, dangerous PHP functions are turned off with `disable_functions = exec,passthru,shell_exec,system,proc_open,popen`.
- Safe to run again. Running `./install.sh` a second time updates your config or adds packages without breaking what is already there.
- Downloads are checked. Composer and phpMyAdmin are verified against their published checksums during installation.
- Configuration backup. Files you want kept across reinstalls go in `config/private/backup/`. After a reinstall, the installer copies them back for you. It only copies configuration files. It never touches your sessions, databases, or other runtime files.
