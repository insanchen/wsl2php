# WSL2PHP - Turn WSL into PHP Development Environment
This script will turn your WSL (Windows Subsystem for Linux) into a PHP development environment.\
It will install and configure web server (Apache or NGINX), MariaDB, Single/Multiple PHP versions, and other tools like Composer, Git, and more.

## Quick Start
You can use the following commands to start the script:
```
git clone https://github.com/insanchen/wsl2php.git
cd wsl2php
chmod +x install.sh
./install.sh
```
When you run the script, it will ask you to use default values as described below.
```
SERVER_NAME="localhost"
SERVER_ALIAS="www.example.com"
SERVER_ROOT="/var/www"
SERVER_APP="html"
SERVER_TZ="Asia/Jakarta"
INSTALL_PHP=Y
INSTALL_PHP_VERSION=("7.4" "8.1")
INSTALL_NGINX=Y
INSTALL_APACHE=Y
INSTALL_MARIADB=Y
INSTALL_REDIS=Y
INSTALL_PHPMYADMIN=Y
INSTALL_NODEJS=Y
INSTALL_COMPOSER=Y
```
Press `Y` to accept the default value or press `N` to enter interactive mode and enter your own value.

After installation, restart WSL2 by running the following command in powershell: `wsl --shutdown` and then start WSL2 again.

## Starting up
You can start the services by running the following commands:
- `phpboot` to start the PHP service.
- `ap2boot` to start the Apache2 service.
- `ngxboot` to start the Nginx service.
- `mdbboot` to start the MariaDB service.
- `redisboot` to start the Redis service.

OR simply:
- `lampx` to start PHP, Apache2, and MariaDB.
- `lempx` to start PHP, Nginx, and MariaDB.
- `leampx` to start PHP, Nginx, Apache2, and MariaDB.

## Using multiple PHP versions
If you are using `Apache2`, you can use the following command to switch to another php version:
- `phpset7` to switch to php7.4
- `phpset8` to switch to php8.1

You can add/modify more php versions by adding more `phpset` commands in the `~/.bash_aliases` file.

If you are using `Nginx`, you can configure it in the server block by running the following command: `ngxedit`
```
location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    include fastcgi_params;
    fastcgi_pass unix:/run/php/php7.4-fpm.sock;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
}
```
Edit this line `fastcgi_pass unix:/run/php/php7.4-fpm.sock;` and change to the version you want to use, then run `ngxload` to reload the Nginx configuration.

## Other commands
Example commands for `Apache2`:
- `ap2edit` to edit the Apache2 configuration.
- `ap2load` to reload Apache2 configuration.
- `ap2stat` to check the status of Apache2.
- `ap2tail` to tail the Apache2 log.

Example commands for `Nginx`:
- `ngxedit` to edit the Nginx configuration.
- `ngxload` to reload Nginx configuration.
- `ngxstat` to check the status of Nginx.
- `ngxtail` to tail the Nginx log.

Example commands for `MariaDB`:
- `mdbedit` to edit the MariaDB configuration.
- `mdbstat` to check the status of MariaDB.
- `mdbexp <db name>` to export database(s).
- `mdbimp <file> <db name>` to import database.

You can find more commands in the `~/.bash_aliases` file and add or edit them to your needs.

## Installing on real server
This script can also be used to install on real server.

There are things you need to do before executing `install.sh` file:
1. Put your ssl certificate files in the `config/ssl` directory and rename it using your server name for example:
   - `mydomain.com.pem`
   - `mydomain.com.key`
2. Review the server configuration files (all files begin with `server` in each respective directory) and change accordingly.
3. Run the script using interactive mode and change the `SERVER_NAME` and `SERVER_ALIAS` to your server name.
   ```
   Server Name [localhost]: mydomain.com
   Server Alias [www.example.com]: app.mydomain.com
   ```
