# 🚀 WSL2PHP - Transform WSL into a Powerful PHP Development Environment!

WSL2PHP is your go-to solution for turning Windows Subsystem for Linux (WSL) into a fully-featured PHP development environment. This script handles the installation and configuration of essential tools like Apache, NGINX, MariaDB, multiple PHP versions, and other must-haves like Composer and Git.

## ⚡ Quick Start

Get started in no time with these simple steps:

```bash
git clone https://github.com/insanchen/wsl2php.git
cd wsl2php
chmod +x install.sh
./install.sh
```

You’ll be prompted to use default values or customize them. Here's what the defaults look like:

```bash
SERVER_NAME="localhost"
SERVER_ALIAS="www.example.com"
SERVER_ROOT="/var/www"
SERVER_APP="html"
SERVER_TZ="Asia/Jakarta"
INSTALL_PHP=Y
INSTALL_PHP_VERSION=("5.6" "7.4" "8.1" "8.2" "8.3" "8.4")
INSTALL_NGINX=Y
INSTALL_APACHE=Y
INSTALL_MARIADB=Y
INSTALL_REDIS=Y
INSTALL_PHPMYADMIN=Y
INSTALL_NODEJS=Y
INSTALL_COMPOSER=Y
```

Press `Y` to accept the default value or press `N` to enter interactive mode and enter your own value.

## ✨ Restart WSL After Installation

Once done, restart WSL2 with the following command:

```bash
wsl --shutdown
```

## 🛠️ Starting Your Development Environment

Simplify your workflow with these commands:

Individual Services:

-   `phpboot` # Start PHP service
-   `ap2boot` # Start Apache2
-   `ngxboot` # Start NGINX
-   `mdbboot` # Start MariaDB
-   `redisboot` # Start Redis

Combined Services:

-   `lampx` # Start PHP, Apache2, MariaDB
-   `lempx` # Start PHP, NGINX, MariaDB
-   `leampx` # Start PHP, NGINX, Apache2, MariaDB

## 🌈 Switching Between PHP Versions

Use these commands to switch PHP versions when using `Apache2`:

-   `phpset56` # Switch to PHP 5.6
-   `phpset74` # Switch to PHP 7.4
-   `phpset81` # Switch to PHP 8.1
-   `phpset82` # Switch to PHP 8.2
-   `phpset83` # Switch to PHP 8.3
-   `phpset84` # Switch to PHP 8.4

For `NGINX`, edit your server block using `ngxedit`:

```bash
location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    include fastcgi_params;
    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
```

Update the `fastcgi_pass` line to the desired PHP version and reload the configuration with:

```bash
ngxload
```

## 🔍 Handy Commands for Config Management

Apache2

-   `ap2edit` - Edit configuration
-   `ap2load` - Reload configuration
-   `ap2stat` - Check status
-   `ap2tail` - View logs

NGINX

-   `ngxedit` - Edit configuration
-   `ngxload` - Reload configuration
-   `ngxstat` - Check status
-   `ngxtail` - View logs

MariaDB

-   `mdbedit` - Edit configuration
-   `mdbstat` - Check status
-   `mdbexp` <db_name> - Export database
-   `mdbimp` <file> <db_name> - Import database

Explore and customize more commands in the ~/.bash_aliases file.

## 🌐 Deploying on Real Servers

Want to deploy on a real server? Here's what to do before running the script:

1.  Place your SSL certificate files in `config/ssl`:
    -   `mydomain.com.pem`
    -   `mydomain.com.key`
2.  Adjust server configurations in files prefixed with server in their respective directories.
3.  Run the script in interactive mode to set custom values:
    ```bash
    Server Name [localhost]: mydomain.com
    Server Alias [www.example.com]: app.mydomain.com
    ```

## 🌟 Why WSL2PHP?

-   Seamless integration of PHP tools and services
-   Hassle-free multi-version PHP support
-   Tailored for both local development and real server deployment
-   Highly customizable configurations

Get started today and experience effortless PHP development on WSL2! 😎
