#!/bin/bash
# Default Configuration
SERVER_NAME="localhost"
SERVER_ALIAS="www.example.com"
SERVER_ROOT="/var/www"
SERVER_APP="html"
SERVER_TZ="Asia/Jakarta"
INSTALL_PHP=Y
INSTALL_PHP_VERSION=("5.6" "7.4" "8.3")
INSTALL_NGINX=Y
INSTALL_APACHE=Y
INSTALL_MARIADB=Y
INSTALL_REDIS=Y
INSTALL_PHPMYADMIN=Y
INSTALL_NODEJS=Y
INSTALL_COMPOSER=Y
DEFAULT_PACKAGE="bash-completion bc dos2unix git htop net-tools pigz pv ssl-cert sudo unzip xz-utils"

function intro() {
    showheader
    printf "Use default configuration? [Y/\x1B[33mN\x1B[0m]: "
    read USE_DEFAULT_CONFIG
    if [[ $USE_DEFAULT_CONFIG =~ ^(y|Y)$ ]]; then getpackage; else reconfig; fi
}

function showheader() {
    clear
    printf "\x1B[32m"
    printf '*%.0s' {1..100}
    printf "\n"
    printf "* %s\n" "Welcome to the PHP MariaDB Web Server Installer"
    printf "* %s\n" "This script will guide you to install the PHP MariaDB Web Server"
    printf "* %s\n" "on your WSL (Windows Subsystem for Linux) or Linux Machine"
    printf '*%.0s' {1..100}
    printf "\x1B[0m\n\n"
}

function reconfig() {
    showheader
    printf "Please answer the following questions.\n"
    printf "Server Name [\x1B[33mlocalhost\x1B[0m]: "
    read SERVER_NAME
    SERVER_NAME=${SERVER_NAME:-localhost}
    SERVER_NAME=${SERVER_NAME,,}
    printf "Server Alias [\x1B[33mwww.example.com\x1B[0m]: "
    read SERVER_ALIAS
    SERVER_ALIAS=${SERVER_ALIAS:-www.example.com}
    SERVER_ALIAS=${SERVER_ALIAS,,}
    printf "Server Root [\x1B[33m/var/www\x1B[0m]: "
    read SERVER_ROOT
    SERVER_ROOT=${SERVER_ROOT:-/var/www}
    SERVER_ROOT=${SERVER_ROOT,,}
    printf "Server App [\x1B[33mhtml\x1B[0m]: "
    read SERVER_APP
    SERVER_APP=${SERVER_APP:-html}
    SERVER_APP=${SERVER_APP,,}
    printf "Server Timezone [\x1B[33mAsia/Jakarta\x1B[0m]: "
    read SERVER_TZ
    SERVER_TZ=${SERVER_TZ:-Asia/Jakarta}
    printf "Install PHP? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_PHP
    INSTALL_PHP=${INSTALL_PHP:-N}
    INSTALL_PHP=${INSTALL_PHP^}
    INSTALL_PHP_VERSION=()
    if [[ $INSTALL_PHP =~ ^(y|Y)$ ]]; then
        printf "Enter PHP Version(s) separated by space [\x1B[33m7.4\x1B[0m]: "
        read INSTALL_PHP_VERSION
        INSTALL_PHP_VERSION=${INSTALL_PHP_VERSION:-7.4}
    fi
    printf "Install Nginx? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_NGINX
    INSTALL_NGINX=${INSTALL_NGINX:-N}
    INSTALL_NGINX=${INSTALL_NGINX^}
    printf "Install Apache? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_APACHE
    INSTALL_APACHE=${INSTALL_APACHE:-N}
    INSTALL_APACHE=${INSTALL_APACHE^}
    printf "Install MariaDB? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_MARIADB
    INSTALL_MARIADB=${INSTALL_MARIADB:-N}
    INSTALL_MARIADB=${INSTALL_MARIADB^}
    printf "Install Redis? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_REDIS
    INSTALL_REDIS=${INSTALL_REDIS:-N}
    INSTALL_REDIS=${INSTALL_REDIS^}
    printf "Install phpMyAdmin? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_PHPMYADMIN
    INSTALL_PHPMYADMIN=${INSTALL_PHPMYADMIN:-N}
    INSTALL_PHPMYADMIN=${INSTALL_PHPMYADMIN^}
    printf "Install NodeJS? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_NODEJS
    INSTALL_NODEJS=${INSTALL_NODEJS:-N}
    INSTALL_NODEJS=${INSTALL_NODEJS^}
    printf "Install Composer? [Y/\x1B[33mN\x1B[0m]: "
    read INSTALL_COMPOSER
    INSTALL_COMPOSER=${INSTALL_COMPOSER:-N}
    INSTALL_COMPOSER=${INSTALL_COMPOSER^}
    getpackage
}

function getpackage() {
    PACKAGE=$DEFAULT_PACKAGE
    if [[ $INSTALL_PHP =~ ^(y|Y)$ ]]; then
        for ver in ${INSTALL_PHP_VERSION[@]}; do
            PACKAGE="$PACKAGE php$ver-bcmath php$ver-bz2 php$ver-curl php$ver-fpm php$ver-gd php$ver-intl php$ver-ldap php$ver-mbstring php$ver-mysql php$ver-redis php$ver-soap php$ver-xml php$ver-xmlrpc php$ver-zip"
        done
    fi
    if [[ $INSTALL_NGINX =~ ^(y|Y)$ ]]; then PACKAGE="$PACKAGE nginx"; fi
    if [[ $INSTALL_APACHE =~ ^(y|Y)$ ]]; then PACKAGE="$PACKAGE apache2 apache2-utils libapache2-mod-fcgid"; fi
    if [[ $INSTALL_MARIADB =~ ^(y|Y)$ ]]; then PACKAGE="$PACKAGE mariadb-server"; fi
    if [[ $INSTALL_REDIS =~ ^(y|Y)$ ]]; then PACKAGE="$PACKAGE redis-server"; fi
    if [[ $INSTALL_NODEJS =~ ^(y|Y)$ ]]; then PACKAGE="$PACKAGE nodejs"; fi
    confirmpackage
}

function confirmpackage() {
    showheader
    printf "\x1B[31mPlease confirm the following configuration.\x1B[0m\n"
    printf "* Install PHP        : \x1B[33m${INSTALL_PHP} ${INSTALL_PHP_VERSION[*]}\x1B[0m\n"
    printf "* Install Nginx      : \x1B[33m${INSTALL_NGINX}\x1B[0m      \t* Server Name     : \x1B[33m${SERVER_NAME}\x1B[0m\n"
    printf "* Install Apache     : \x1B[33m${INSTALL_APACHE}\x1B[0m     \t* Server Alias    : \x1B[33m${SERVER_ALIAS}\x1B[0m\n"
    printf "* Install MariaDB    : \x1B[33m${INSTALL_MARIADB}\x1B[0m    \t* Server Root     : \x1B[33m${SERVER_ROOT}\x1B[0m\n"
    printf "* Install Redis      : \x1B[33m${INSTALL_REDIS}\x1B[0m      \t* Server App      : \x1B[33m${SERVER_APP}\x1B[0m\n"
    printf "* Install phpMyAdmin : \x1B[33m${INSTALL_PHPMYADMIN}\x1B[0m \t* Server Timezone : \x1B[33m$SERVER_TZ\x1B[0m\n"
    printf "* Install Node.js    : \x1B[33m${INSTALL_NODEJS}\x1B[0m\n"
    printf "* Install Composer   : \x1B[33m${INSTALL_COMPOSER}\x1B[0m\n"
    printf "\nList of packages to be installed:\n"
    printf "\x1B[33m$PACKAGE\x1B[0m\n\n" | fold -s -w 100
    printf "Continue using these configuration? [Y/\x1B[33mN\x1B[0m]: "
    read CONFIRM_CONFIG
    if [[ $CONFIRM_CONFIG =~ ^(y|Y)$ ]]; then repoupdate; else reconfig; fi
}

function repoupdate() {
    printf "\n>>> Updating packages repositories...\n"
    if [ "$(whoami)" != "root" ]; then SUDO=sudo; fi
    ${SUDO} apt update
    ${SUDO} apt install curl wget gnupg2 ca-certificates lsb-release apt-transport-https -y
    if [[ "$(lsb_release -si)" =~ "Ubuntu" ]]; then
        ${SUDO} apt install software-properties-common -y
    fi
    if [[ $INSTALL_PHP =~ ^(y|Y)$ ]]; then
        printf "\n>>> Adding PHP repository...\n"
        if [[ "$(lsb_release -si)" =~ "Ubuntu" ]]; then
            ${SUDO} add-apt-repository -n ppa:ondrej/php -y &>/dev/null
        fi
        if [[ "$(lsb_release -si)" =~ "Debian" ]]; then
            ${SUDO} curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
            if [[ ! -f /etc/apt/sources.list.d/php.list ]]; then ${SUDO} sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'; fi
        fi
    fi
    if [[ $INSTALL_NGINX =~ ^(y|Y)$ ]]; then
        printf "\n>>> Adding Nginx repository...\n"
        if [[ "$(lsb_release -si)" =~ "Ubuntu" ]]; then
            ${SUDO} add-apt-repository -n ppa:ondrej/nginx -y &>/dev/null
        fi
        if [[ "$(lsb_release -si)" =~ "Debian" ]]; then
            ${SUDO} curl -sSLo /usr/share/keyrings/deb.sury.org-nginx.gpg https://packages.sury.org/nginx/apt.gpg
            if [[ ! -f /etc/apt/sources.list.d/nginx.list ]]; then ${SUDO} sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-nginx.gpg] https://packages.sury.org/nginx/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/nginx.list'; fi
        fi
    fi
    if [[ $INSTALL_APACHE =~ ^(y|Y)$ ]]; then
        printf "\n>>> Adding Apache repository...\n"
        if [[ "$(lsb_release -si)" =~ "Ubuntu" ]]; then
            ${SUDO} add-apt-repository -n ppa:ondrej/apache2 -y &>/dev/null
        fi
        if [[ "$(lsb_release -si)" =~ "Debian" ]]; then
            ${SUDO} curl -sSLo /usr/share/keyrings/deb.sury.org-apache2.gpg https://packages.sury.org/apache2/apt.gpg
            if [[ ! -f /etc/apt/sources.list.d/apache2.list ]]; then ${SUDO} sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-apache2.gpg] https://packages.sury.org/apache2/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/apache2.list'; fi
        fi
    fi
    if [[ $INSTALL_MARIADB =~ ^(y|Y)$ ]]; then
        printf "\n>>> Adding MariaDB repository...\n"
        # if [[ "$(lsb_release -si)" =~ "Ubuntu" ]]; then
        #     ${SUDO} mkdir -p /etc/apt/keyrings
        #     ${SUDO} curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'
        #     if [[ ! -f /etc/apt/sources.list.d/mariadb.list ]]; then ${SUDO} sh -c "echo 'deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirrors.xtom.com.hk/mariadb/repo/10.11/ubuntu jammy main' > /etc/apt/sources.list.d/mariadb.list"; fi
        # fi
        # if [[ "$(lsb_release -si)" =~ "Debian" ]]; then
        #     ${SUDO} mkdir -p /etc/apt/keyrings
        #     ${SUDO} curl -o /etc/apt/keyrings/mariadb-keyring.pgp 'https://mariadb.org/mariadb_release_signing_key.pgp'
        #     if [[ ! -f /etc/apt/sources.list.d/mariadb.list ]]; then ${SUDO} sh -c "echo 'deb [signed-by=/etc/apt/keyrings/mariadb-keyring.pgp] https://mirrors.xtom.com.hk/mariadb/repo/10.11/debian bullseye main' > /etc/apt/sources.list.d/mariadb.list"; fi
        # fi
    fi
    if [[ $INSTALL_NODEJS =~ ^(y|Y)$ ]]; then
        printf "\n>>> Adding Node.js repository...\n"
        # curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        ${SUDO} mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | ${SUDO} gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | ${SUDO} tee /etc/apt/sources.list.d/nodesource.list
    fi
    if [[ $INSTALL_CLOUDFLARED =~ ^(y|Y)$ ]]; then
        printf "\n>>> Adding Cloudflare repository...\n"
        ${SUDO} mkdir -p --mode=0755 /usr/share/keyrings
        curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | ${SUDO} tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
        echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared bookworm main' | ${SUDO} tee /etc/apt/sources.list.d/cloudflared.list
    fi
    printf "*** Done ***\n"
    packageinstall
}

function packageinstall() {
    printf "\n>>> Installing packages...\n"
    ${SUDO} apt update
    ${SUDO} apt full-upgrade -yy
    ${SUDO} apt install $PACKAGE -yy
    if [[ $INSTALL_PHPMYADMIN =~ ^(y|Y)$ ]]; then
        printf "\n>>> Installing phpMyAdmin...\n"
        ${SUDO} rm -rf /usr/share/phpmyadmin &&
            wget -P /tmp https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz &&
            tar xzf /tmp/phpMyAdmin-latest-all-languages.tar.gz -C /tmp &&
            ${SUDO} mv /tmp/phpMyAdmin-*/ /usr/share/phpmyadmin &&
            ${SUDO} mkdir -p /usr/share/phpmyadmin/tmp &&
            ${SUDO} chmod 777 /usr/share/phpmyadmin/tmp &&
            ${SUDO} chown -R www-data:www-data /usr/share/phpmyadmin &&
            rm -rf /tmp/phpMyAdmin-*
        printf "*** Done ***\n\n"
    fi
    if [[ $INSTALL_NODEJS =~ ^(y|Y)$ ]]; then
        ${SUDO} corepack enable
        ${SUDO} npm install npm@latest -g
    fi
    if [[ $INSTALL_COMPOSER =~ ^(y|Y)$ ]]; then
        COMPOSER_INSTALLER_HASH=$(curl -sS https://composer.github.io/installer.sha384sum | cut -d ' ' -f1);
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&
            php -r "if (hash_file('sha384', 'composer-setup.php') === '$COMPOSER_INSTALLER_HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&
            php composer-setup.php &&
            php -r "unlink('composer-setup.php');" &&
            ${SUDO} mv composer.phar /usr/local/bin/composer
        ${SUDO} chmod a+rx /usr/local/bin/composer
    fi
    printf "*** Done ***\n"
    config_server
}

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
        ${SUDO} rm /etc/php/$ver/fpm/pool.d/*.conf
        ${SUDO} cp -r config/php/$INSTALL_NAME/$ver /etc/php/
        if [[ $INSTALL_REDIS =~ ^(y|Y)$ ]]; then
            ${SUDO} sed -i -e "s|session.save_handler = files|session.save_handler = redis|g" /etc/php/$ver/fpm/php.ini
            ${SUDO} sed -i -e "s|;session.save_path|session.save_path|g" /etc/php/$ver/fpm/php.ini
            ${SUDO} sed -i -e "s|/var/lib/php/sessions|/run/redis/redis-server.sock?persistent=1|g" /etc/php/$ver/fpm/php.ini
        fi
        ${SUDO} chmod 644 /etc/php/$ver/fpm/pool.d/*.conf
        printf "*** Done ***\n"
    done
}

function config_nginx() {
    printf "\n>>> Configuring Nginx...\n"
    local NGINX_SSL_DIR="/etc/nginx/ssl"
    local NGINX_SITE_DIR="/etc/nginx/sites-available"
    local NGINX_CONF_FILE="/etc/nginx/nginx.conf"
    local NGINX_SEC_CONF_FILE="/etc/nginx/conf-security.conf"
    if [[ ! -f $NGINX_CONF_FILE.bak ]]; then ${SUDO} cp $NGINX_CONF_FILE $NGINX_CONF_FILE.bak; fi
    ${SUDO} cp config/nginx/conf-*.conf /etc/nginx/
    ${SUDO} cp config/nginx/$INSTALL_NAME.nginx.conf $NGINX_CONF_FILE
    ${SUDO} touch $NGINX_SITE_DIR/$SERVER_NAME.conf
    ${SUDO} cp config/nginx/$INSTALL_NAME.conf $NGINX_SITE_DIR/$SERVER_NAME.conf
    ${SUDO} mkdir -p $NGINX_SSL_DIR
    ${SUDO} cp config/ssl/$SERVER_NAME.pem $NGINX_SSL_DIR/$SERVER_NAME.pem
    ${SUDO} cp config/ssl/$SERVER_NAME.key $NGINX_SSL_DIR/$SERVER_NAME.key
    ${SUDO} openssl dhparam -out /etc/nginx/dhparam.pem 2048
    if [ "$SERVER_NAME" != "localhost" ]; then
        ${SUDO} cp config/ssl/cloudflare.pem $NGINX_SSL_DIR/cloudflare.pem
        ${SUDO} cat $NGINX_SSL_DIR/$SERVER_NAME.pem $NGINX_SSL_DIR/cloudflare.pem >$NGINX_SSL_DIR/$SERVER_NAME.crt
        ${SUDO} chown root:root $NGINX_SSL_DIR/cloudflare.pem $NGINX_SSL_DIR/$SERVER_NAME.crt
        ${SUDO} chmod 600 $NGINX_SSL_DIR/cloudflare.pem $NGINX_SSL_DIR/$SERVER_NAME.crt
        ${SUDO} sed -i -e "s|servername|$SERVER_NAME|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        ${SUDO} sed -i -e "s|serveralias|$SERVER_ALIAS|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        ${SUDO} sed -i -e "s|serverroot|$SERVER_ROOT|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        ${SUDO} sed -i -e "s|serverapp|$SERVER_APP|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        if ((${#INSTALL_PHP[@]} > 0)); then
            for ver in "${INSTALL_PHP_VERSION[@]}"; do PHPVER=$ver; done
            ${SUDO} sed -i -e "s|php-|php$PHPVER-|g" $NGINX_SITE_DIR/$SERVER_NAME.conf
        fi
        if [[ $INSTALL_PHPMYADMIN =~ ^(y|Y)$ ]]; then ${SUDO} sed -i -e "s|# include conf-phpmyadmin.conf|include conf-phpmyadmin.conf|g" $NGINX_SITE_DIR/$SERVER_NAME.conf; fi
        ${SUDO} sed -i -e "s|#add_header|add_header|g" $NGINX_SEC_CONF_FILE
    fi
    ${SUDO} chown root:root $NGINX_SSL_DIR/$SERVER_NAME.pem $NGINX_SSL_DIR/$SERVER_NAME.key
    ${SUDO} chmod 600 $NGINX_SSL_DIR/$SERVER_NAME.pem $NGINX_SSL_DIR/$SERVER_NAME.key
    ${SUDO} chmod 644 $NGINX_CONF_FILE $NGINX_SITE_DIR/$SERVER_NAME.conf /etc/nginx/conf-*.conf
    ${SUDO} ln -s $NGINX_SITE_DIR/$SERVER_NAME.conf /etc/nginx/sites-enabled/$SERVER_NAME.conf
    ${SUDO} unlink /etc/nginx/sites-enabled/default
    ${SUDO} systemctl enable nginx.service
    printf "*** Done ***\n"
}

function config_apache() {
    printf "\n>>> Configuring Apache...\n"
    local APACHE_SSL_DIR="/etc/apache2/ssl"
    local APACHE_SITE_DIR="/etc/apache2/sites-available"
    ${SUDO} touch $APACHE_SITE_DIR/$SERVER_NAME.conf
    ${SUDO} cp config/apache/$INSTALL_NAME.conf $APACHE_SITE_DIR/$SERVER_NAME.conf
    ${SUDO} mkdir -p $APACHE_SSL_DIR
    ${SUDO} cp config/ssl/$SERVER_NAME.pem $APACHE_SSL_DIR/$SERVER_NAME.pem
    ${SUDO} cp config/ssl/$SERVER_NAME.key $APACHE_SSL_DIR/$SERVER_NAME.key
    if [ "$SERVER_NAME" != "localhost" ]; then
        ${SUDO} cp config/ssl/cloudflare.pem $APACHE_SSL_DIR/cloudflare.pem
        ${SUDO} chown root:root $APACHE_SSL_DIR/cloudflare.pem
        ${SUDO} chmod 600 $APACHE_SSL_DIR/cloudflare.pem
        ${SUDO} sed -i -e "s|servername|$SERVER_NAME|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        ${SUDO} sed -i -e "s|serveralias|$SERVER_ALIAS|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        ${SUDO} sed -i -e "s|serverroot|$SERVER_ROOT|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        ${SUDO} sed -i -e "s|serverapp|$SERVER_APP|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        if ((${#INSTALL_PHP[@]} > 0)); then
            for ver in "${INSTALL_PHP_VERSION[@]}"; do PHPVER=$ver; done
            ${SUDO} sed -i -e "s|php-|php$PHPVER-|g" $APACHE_SITE_DIR/$SERVER_NAME.conf
        fi
    fi
    ${SUDO} chown root:root $APACHE_SSL_DIR/$SERVER_NAME.pem $APACHE_SSL_DIR/$SERVER_NAME.key
    ${SUDO} chmod 600 $APACHE_SSL_DIR/$SERVER_NAME.pem $APACHE_SSL_DIR/$SERVER_NAME.key
    ${SUDO} chmod 644 $APACHE_SITE_DIR/$SERVER_NAME.conf
    ${SUDO} a2dissite 000-default.conf
    ${SUDO} a2ensite $SERVER_NAME.conf
    ${SUDO} a2dismod mpm_prefork
    ${SUDO} a2enmod actions fcgid alias mpm_event proxy_fcgi setenvif rewrite ssl
    for ver in $(ls /etc/php); do ${SUDO} a2disconf php$ver-fpm; done
    ${SUDO} a2enconf php7.4-fpm
    ${SUDO} systemctl enable apache2.service
    printf "*** Done ***\n"
}

function config_mariadb() {
    printf "\n>>> Configuring MariaDB...\n"
    mkdir -p ~/script
    wget http://mysqltuner.pl/ -O ~/script/mysqltuner.pl
    wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/basic_passwords.txt -O ~/script/basic_passwords.txt
    wget https://raw.githubusercontent.com/major/MySQLTuner-perl/master/vulnerabilities.csv -O ~/script/vulnerabilities.csv
    wget https://raw.githubusercontent.com/BMDan/tuning-primer.sh/main/tuning-primer.sh -O ~/script/tuning-primer.sh
    local MYSQL_CONF_FILE="/etc/my.cnf"
    local MYSQL_SCONF_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
    local MYSQL_LOG_DIR="/var/log/mysql"
    ${SUDO} touch $MYSQL_CONF_FILE
    ${SUDO} cp config/mysql/$INSTALL_NAME.my.cnf $MYSQL_CONF_FILE
    ${SUDO} chmod 644 $MYSQL_CONF_FILE
    ${SUDO} sed -i -e "s|bind-address|#bind-address|g" $MYSQL_SCONF_FILE
    ${SUDO} sed -i -e "s|##|#|g" $MYSQL_SCONF_FILE
    ${SUDO} mkdir -p $MYSQL_LOG_DIR
    ${SUDO} chown mysql:mysql $MYSQL_LOG_DIR
    ${SUDO} service mariadb start && sleep 2 && ${SUDO} mariadb <initdb.sql
    ${SUDO} systemctl enable mariadb.service
    printf "*** Done ***\n"
}

function config_redis() {
    printf "\n>>> Configuring Redis...\n"
    local REDIS_CONF_FILE="/etc/redis/redis.conf"
    ${SUDO} sed -i -e "s|# unixsocket|unixsocket|g" $REDIS_CONF_FILE
    ${SUDO} sed -i -e "s|unixsocketperm 700|unixsocketperm 770|g" $REDIS_CONF_FILE
    ${SUDO} sed -i -e "s|loglevel notice|loglevel warning|g" $REDIS_CONF_FILE
    ${SUDO} usermod -aG redis www-data
    ${SUDO} systemctl enable redis-server.service
    printf "*** Done ***\n"
}

function config_phpmyadmin() {
    printf "\n>>> Configuring phpMyAdmin...\n"
    local PMA_DIR="/usr/share/phpmyadmin"
    local PMA_CONF_FILE="$PMA_DIR/config.inc.php"
    ${SUDO} touch $PMA_CONF_FILE
    ${SUDO} cp config/phpmyadmin/config.inc.php $PMA_CONF_FILE
    ${SUDO} sed -i -e "s|~replacethiswithsomethingsecret~|$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)|g" $PMA_CONF_FILE
    ${SUDO} chmod 644 $PMA_CONF_FILE
    ${SUDO} chown www-data:www-data $PMA_CONF_FILE
    printf "*** Done ***\n"
}

function config_enviroment() {
    printf "\n>>> Configuring enviroment...\n"
    ${SUDO} setcap cap_net_raw+p /bin/ping
    ${SUDO} truncate -s 0 /etc/motd
    touch ~/.hushlogin
    cp config/.bash_aliases ~/.bash_aliases
    if [ "$SERVER_NAME" != "localhost" ]; then ${SUDO} sed -i -e "s|localhost|$SERVER_NAME|g" ~/.bash_aliases; fi
    ${SUDO} chmod 644 ~/.bash_aliases
    printf "*** Done ***\n"
}

function config_timezone() {
    printf "\n>>> Configuring timezone...\n"
    if [ "$SERVER_NAME" != "localhost" ]; then
        ${SUDO} timedatectl set-timezone $SERVER_TZ
    else
        ${SUDO} rm -rf /etc/localtime
        ${SUDO} ln -sf /usr/share/zoneinfo/$SERVER_TZ /etc/localtime
    fi
    printf "*** Done ***\n"
}

function cleanup() {
    printf "\n>>> Cleaning up...\n"
    ${SUDO} apt update
    ${SUDO} apt full-upgrade -y
    ${SUDO} apt autoremove --purge -y
    ${SUDO} apt autoclean -y
    ${SUDO} apt clean -y
    ${SUDO} journalctl --vacuum-size 10M
    ${SUDO} find /var/log -type f -regex '.*\.gz$' -delete
    ${SUDO} find /var/log -type f -regex '.*\.[0-9|gz]$' -delete
    ${SUDO} truncate -s 0 /var/log/**/*.log
    ${SUDO} find /usr/share/doc -depth -type f -delete
    ${SUDO} rm -rf /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /var/cache/man/*
    ${SUDO} rm -r ~/.local/share/Trash/info/
    ${SUDO} rm -r ~/.local/share/Trash/files/
    ${SUDO} rm ~/.bash_history
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

intro
