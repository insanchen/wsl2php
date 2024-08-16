# Composer
export PATH=$PATH:~/.config/composer/vendor/bin:~/.local/bin

# Networking
alias showip="ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'"
alias shownet="sudo netstat -tlpn"

# Cleaning
alias aptclear="sudo apt autoremove -y --purge && sudo apt autoclean -y && sudo apt clean -y"
alias logclear="sudo find /var/log -type f -regex '.*\.gz$' -delete && sudo find /var/log -type f -regex '.*\.[0-9]$' -delete && sudo truncate -s 0 /var/log/*.log && sudo truncate -s 0 /var/log/**/*.log && sudo truncate -s 0 ~/.bash_history"
alias allclear="aptclear && logclear"

# PHP
phpboot() { sudo mkdir -p /run/php && for ver in $(ls /etc/php); do sudo service php$ver-fpm restart; done; }
phpload() { for ver in $(ls /etc/php); do sudo service php$ver-fpm reload; done; }
phpstop() { for ver in $(ls /etc/php); do sudo service php$ver-fpm stop; done; }
alias phptail="sudo truncate -s 0 /var/log/php*.log && sudo tail -f /var/log/php*.log"

# PHP Apache
phpunset() { for ver in $(ls /etc/php); do sudo a2disconf php$ver-fpm; done; }
alias phpset5="phpunset && sudo a2enconf php5.6-fpm && ap2load"
alias phpset7="phpunset && sudo a2enconf php7.4-fpm && ap2load"
alias phpset8="phpunset && sudo a2enconf php8.3-fpm && ap2load"

# Redis
alias redisboot="sudo service redis-server restart"
alias redisconf="sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.bak && sudo truncate -s 0 /etc/redis/redis.conf && sudo nano /etc/redis/redis.conf"
alias redisedit="sudo nano /etc/redis/redis.conf"
alias redisstat="sudo service redis-server status"
alias redisstop="sudo service redis-server stop"
alias redistail="sudo truncate -s 0 /var/log/redis/redis-server.log && sudo tail -f /var/log/redis/redis-server.log"

# Apache2
alias ap2boot="sudo service apache2 restart"
alias ap2conf="sudo cp /etc/apache2/sites-available/localhost.conf /etc/apache2/sites-available/localhost.conf.bak && sudo truncate -s 0 /etc/apache2/sites-available/localhost.conf && sudo nano /etc/apache2/sites-available/localhost.conf"
alias ap2edit="sudo nano /etc/apache2/sites-available/localhost.conf"
alias ap2load="sudo service apache2 reload"
alias ap2stat="sudo service apache2 status"
alias ap2stop="sudo service apache2 stop"
alias ap2tail="sudo truncate -s 0 /var/log/apache2/*.log && sudo tail -f /var/log/apache2/*.log"

# Nginx
alias ngxboot="sudo service nginx restart"
alias ngxconf="sudo cp /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-available/localhost.conf.bak && sudo truncate -s 0 /etc/nginx/sites-available/localhost.conf && sudo nano /etc/nginx/sites-available/localhost.conf"
alias ngxedit="sudo nano /etc/nginx/sites-available/localhost.conf"
alias ngxload="sudo service nginx reload"
alias ngxstat="sudo service nginx status"
alias ngxstop="sudo service nginx stop"
alias ngxtail="sudo truncate -s 0 /var/log/nginx/*.log && sudo tail -f /var/log/nginx/*.log"

# MySQL / Mariadb
alias mdbboot="sudo service mariadb restart"
alias mdbconf="sudo cp /etc/my.cnf /etc/my.cnf.bak && sudo truncate -s 0 /etc/my.cnf && sudo nano /etc/my.cnf"
alias mdbedit="sudo nano /etc/my.cnf"
alias mdbstat="sudo service mariadb status"
alias mdbstop="sudo service mariadb stop"
alias mdbtail="sudo truncate -s 0 /var/log/mysql/*.log && sudo tail -f /var/log/mysql/*.log"
alias mdbtune="sudo perl ~/script/mysqltuner.pl --checkversion --updateversion"
mdbexp() {
    local query="SHOW DATABASES WHERE \`Database\`"
    if [ -z "$1" ]; then local param=" NOT REGEXP '(^mysql|_schema$|sys)'"; else local param=" IN ('$1')"; fi
    for database in $(sudo mariadb -e "$query$param" | awk -F " " '{if (NR!=1) print $1}'); do
        echo "Dumping $database..."
        sudo mariadb-dump --single-transaction --events --routines --flush-privileges $database |
            sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' |
            sed -e "s/\`$database\`.//g" |
            pigz -v9 >$database.sql.gz
    done
}
mdbimp() {
    if [ -z "$1" ]; then
        echo "Usage: mdbimp <file> <database>"
    else
        if [ -z "$2" ]; then
            echo "No database specified"
        else
            echo "Importing $1 to $2..."
            if [[ $1 =~ .*.sql.gz$ ]]; then
                pv $1 | gunzip | sudo mariadb $2
            else
                pv $1 | sudo mariadb $2
            fi
        fi
    fi
}

# LAMP/LEMP Stack
alias lampx="logclear && phpboot && ap2boot && mdbboot && redisboot"
alias lempx="logclear && phpboot && ngxboot && mdbboot && redisboot"
alias leampx="logclear && phpboot && ngxboot && ap2boot && mdbboot && redisboot"

# Custom
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias c="clear"
alias h="cd ~"
alias l="ls -alhF"

# Private
alias cc="phpload && redis-cli flushall"
alias gitdiscard="git reset --hard && git clean -dfx"
alias realias="truncate -s 0 ~/.bash_aliases && nano ~/.bash_aliases"
alias ressh="truncate -s 0 ~/.ssh/known_hosts"
alias sshreconf="truncate -s 0 ~/.ssh/config && nano ~/.ssh/config"
alias touchall="find . -exec touch {} \;"