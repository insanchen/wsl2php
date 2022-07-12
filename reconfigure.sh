#!/bin/bash
# Default Configuration
SERVER_NAME="localhost"
SERVER_ALIAS="www.example.com"
SERVER_ROOT="/var/www"
SERVER_APP="html"
SERVER_TZ="Asia/Jakarta"
INSTALL_PHP=N
INSTALL_PHP_VERSION=()
INSTALL_NGINX=N
INSTALL_APACHE=N
INSTALL_MARIADB=N
INSTALL_REDIS=N
INSTALL_PHPMYADMIN=N

function config_server() {
    if [ "$SERVER_NAME" != "localhost" ]; then INSTALL_NAME="server"; else INSTALL_NAME="localhost"; fi
    if [[ $INSTALL_PHP =~ ^(y|Y)$ ]]; then config_php; fi
    if [[ $INSTALL_NGINX =~ ^(y|Y)$ ]]; then config_nginx; fi
    if [[ $INSTALL_APACHE =~ ^(y|Y)$ ]]; then config_apache; fi
    if [[ $INSTALL_MARIADB =~ ^(y|Y)$ ]]; then config_mariadb; fi
    if [[ $INSTALL_REDIS =~ ^(y|Y)$ ]]; then config_redis; fi
    if [[ $INSTALL_PHPMYADMIN =~ ^(y|Y)$ ]]; then config_phpmyadmin; fi
    config_enviroment
    config_timezone
    cleanup
    showfooter
}

function config_php() {
    for ver in "${INSTALL_PHP_VERSION[@]}"; do
        printf "\n>>> Configuring PHP $ver...\n"
        sudo cp -r config/php/$INSTALL_NAME/$ver /etc/php/
        sudo chmod 644 /etc/php/$ver/fpm/pool.d/www.conf
        printf "*** Done ***\n"
    done
}

function config_nginx() {
    printf "\n>>> Configuring Nginx...\n"
    local NGINX_SSL_DIR="/etc/nginx/ssl"
    local NGINX_SITE_DIR="/etc/nginx/sites-available"
    local NGINX_CONF_FILE="/etc/nginx/nginx.conf"
    if [[ ! -f $NGINX_CONF_FILE.bak ]]; then sudo cp $NGINX_CONF_FILE $NGINX_CONF_FILE.bak; fi
    sudo cp config/nginx/$INSTALL_NAME.nginx.conf $NGINX_CONF_FILE
    sudo touch $NGINX_SITE_DIR/$SERVER_NAME.conf
    sudo cp config/nginx/$INSTALL_NAME.conf $NGINX_SITE_DIR/$SERVER_NAME.conf
    if [ "$SERVER_NAME" != "localhost" ]; then
        sudo mkdir -p $NGINX_SSL_DIR
        sudo cp config/ssl/$SERVER_NAME.pem $NGINX_SSL_DIR/$SERVER_NAME.pem
        sudo cp config/ssl/$SERVER_NAME.key $NGINX_SSL_DIR/$SERVER_NAME.key
        sudo cp config/ssl/cloudflare.pem $NGINX_SSL_DIR/cloudflare.pem
        sudo cat $NGINX_SSL_DIR/$SERVER_NAME.pem $NGINX_SSL_DIR/cloudflare.pem >$NGINX_SSL_DIR/bundle.crt
        sudo chmod 600 $NGINX_SSL_DIR/$SERVER_NAME.pem $NGINX_SSL_DIR/$SERVER_NAME.key $NGINX_SSL_DIR/cloudflare.pem $NGINX_SSL_DIR/bundle.crt
        sudo chown root:root $NGINX_SSL_DIR/$SERVER_NAME.pem $NGINX_SSL_DIR/$SERVER_NAME.key $NGINX_SSL_DIR/cloudflare.pem $NGINX_SSL_DIR/bundle.crt
        sudo sed -i -e "s|servername|$SERVER_NAME|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        sudo sed -i -e "s|serveralias|$SERVER_ALIAS|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        sudo sed -i -e "s|serverroot|$SERVER_ROOT|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        sudo sed -i -e "s|serverapp|$SERVER_APP|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        if ((${#INSTALL_PHP[@]} > 0)); then
            for ver in "${INSTALL_PHP_VERSION[@]}"; do PHPVER=$ver; done
            sudo sed -i -e "s|php-|php$PHPVER-|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        fi
    fi
    sudo chmod 644 $NGINX_CONF_FILE $NGINX_SITE_DIR/$SERVER_NAME.conf
    sudo ln -s $NGINX_SITE_DIR/$SERVER_NAME.conf /etc/nginx/sites-enabled/$SERVER_NAME.conf
    sudo unlink /etc/nginx/sites-enabled/default
    sudo systemctl enable nginx.service
    printf "*** Done ***\n"
}

function config_apache() {
    printf "\n>>> Configuring Apache...\n"
    local APACHE_SSL_DIR="/etc/apache2/ssl"
    local APACHE_SITE_DIR="/etc/apache2/sites-available"
    sudo touch $APACHE_SITE_DIR/$SERVER_NAME.conf
    sudo cp config/apache/$INSTALL_NAME.conf $APACHE_SITE_DIR/$SERVER_NAME.conf
    if [ "$SERVER_NAME" != "localhost" ]; then
        sudo mkdir -p $APACHE_SSL_DIR
        sudo cp config/ssl/$SERVER_NAME.pem $APACHE_SSL_DIR/$SERVER_NAME.pem
        sudo cp config/ssl/$SERVER_NAME.key $APACHE_SSL_DIR/$SERVER_NAME.key
        sudo cp config/ssl/cloudflare.pem $APACHE_SSL_DIR/cloudflare.pem
        sudo chmod 600 $APACHE_SSL_DIR/$SERVER_NAME.pem $APACHE_SSL_DIR/$SERVER_NAME.key $APACHE_SSL_DIR/cloudflare.pem
        sudo chown root:root $APACHE_SSL_DIR/$SERVER_NAME.pem $APACHE_SSL_DIR/$SERVER_NAME.key $APACHE_SSL_DIR/cloudflare.pem
        sudo sed -i -e "s|servername|$SERVER_NAME|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        sudo sed -i -e "s|serveralias|$SERVER_ALIAS|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        sudo sed -i -e "s|serverroot|$SERVER_ROOT|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        sudo sed -i -e "s|serverapp|$SERVER_APP|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        if ((${#INSTALL_PHP[@]} > 0)); then
            for ver in "${INSTALL_PHP_VERSION[@]}"; do PHPVER=$ver; done
            sudo sed -i -e "s|php-|php$PHPVER-|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        fi
    fi
    sudo chmod 644 $APACHE_SITE_DIR/$SERVER_NAME.conf
    sudo a2dissite 000-default.conf
    sudo a2ensite $SERVER_NAME.conf
    sudo a2dismod mpm_prefork
    sudo a2enmod actions fcgid alias mpm_event proxy_fcgi setenvif rewrite ssl
    for ver in $(ls /etc/php); do sudo a2disconf php$ver-fpm; done
    sudo a2enconf php7.4-fpm
    sudo systemctl enable apache2.service
    printf "*** Done ***\n"
}

function config_mariadb() {
    printf "\n>>> Configuring MariaDB...\n"
    local MYSQL_CONF_FILE="/etc/my.cnf"
    local MYSQL_SCONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
    sudo touch $MYSQL_CONF_FILE
    sudo cp config/mysql/$INSTALL_NAME.my.cnf $MYSQL_CONF_FILE
    sudo chmod 644 $MYSQL_CONF_FILE
    sudo sed -i -e "s|bind-address|#bind-address|g" $MYSQL_SCONF_FILE
    sudo sed -i -e "s|##|#|g" $MYSQL_SCONF_FILE
    sudo service mysql start && sleep 2 && sudo mysql <initdb.sql && sleep 2 && sudo service mysql stop
    sudo systemctl enable mysql.service
    printf "*** Done ***\n"
}

function config_redis() {
    printf "\n>>> Configuring Redis...\n"
    sudo usermod -aG redis www-data
    sudo systemctl enable redis-server.service
    printf "*** Done ***\n"
}

function config_phpmyadmin() {
    printf "\n>>> Configuring phpMyAdmin...\n"
    local PMA_DIR="/usr/share/phpmyadmin"
    local PMA_CONF_FILE="$PMA_DIR/config.inc.php"
    sudo touch $PMA_CONF_FILE
    sudo cp config/phpmyadmin/config.inc.php $PMA_CONF_FILE
    sudo sed -i -e "s|~replacethiswithsomethingsecret~|$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)|g" $PMA_CONF_FILE
    sudo chmod 644 $PMA_CONF_FILE
    sudo chown www-data:www-data $PMA_CONF_FILE
    printf "*** Done ***\n"
}

function config_enviroment() {
    printf "\n>>> Configuring enviroment...\n"
    touch ~/.hushlogin
    cp config/.bash_aliases ~/.bash_aliases
    if [ "$SERVER_NAME" != "localhost" ]; then sudo sed -i -e "s|localhost|$SERVER_NAME|g" ~/.bash_aliases; fi
    sudo chmod 644 ~/.bash_aliases
    printf "*** Done ***\n"
}

function config_timezone() {
    printf "\n>>> Configuring timezone...\n"
    sudo timedatectl set-timezone $SERVER_TZ
    printf "*** Done ***\n"
}

function cleanup() {
    printf "\n>>> Cleaning up...\n"
    sudo apt update
    sudo apt full-upgrade -y
    sudo apt autoremove --purge -y
    sudo apt autoclean -y
    sudo apt clean -y
    sudo journalctl --vacuum-size 10M
    sudo find /var/log -type f -regex '.*\.gz$' -delete
    sudo find /var/log -type f -regex '.*\.[0-9|gz]$' -delete
    sudo truncate -s 0 /var/log/**/*.log
    sudo find /usr/share/doc -depth -type f -delete
    sudo rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /var/cache/man/*
    sudo rm -r ~/.local/share/Trash/info/
    sudo rm -r ~/.local/share/Trash/files/
    sudo rm ~/.bash_history
    printf "*** Done ***\n"
}

function showfooter() {
    printf "\n>>> Server is ready!\n"
    printf "\x1B[32m"
    printf '*%.0s' {1..40}
    printf "\n"
    printf "* Server Name     : \x1B[33m$SERVER_NAME\x1B[32m\n"
    printf "* Server Alias    : \x1B[33m$SERVER_ALIAS\x1B[32m\n"
    printf "* Server Root     : \x1B[33m$SERVER_ROOT\x1B[32m\n"
    printf "* Server App      : \x1B[33m$SERVER_APP\x1B[32m\n"
    printf "* Server Timezone : \x1B[33m$SERVER_TZ\x1B[32m\n"
    printf '*%.0s' {1..40}
    printf "\x1B[0m\n"
}

config_server