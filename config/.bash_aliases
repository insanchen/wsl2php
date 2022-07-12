# Public shell helpers. Private aliases are appended from config/private/bash_aliases.
for p in "$HOME/.config/composer/vendor/bin" "$HOME/.local/bin"; do
  case ":$PATH:" in *":$p:"*) ;; *) PATH="$PATH:$p" ;; esac
done
export PATH

# Network helpers. Functions are easier to extend and quote safely than aliases.
showip() { ip -o -4 addr show scope global | awk '{print $4}' | cut -d/ -f1; }
alias shownet='sudo ss -tulpn'

_php_versions() {
  [[ -d /etc/php ]] || return 0
  find /etc/php -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort -V
}
phpboot() { sudo mkdir -p /run/php; local ver; while IFS= read -r ver; do sudo service "php${ver}-fpm" restart; done < <(_php_versions); }
phpload() { local ver; while IFS= read -r ver; do sudo service "php${ver}-fpm" reload; done < <(_php_versions); }
phpstop() { local ver; while IFS= read -r ver; do sudo service "php${ver}-fpm" stop; done < <(_php_versions); }
phpunset() { local ver; while IFS= read -r ver; do sudo a2disconf "php${ver}-fpm"; done < <(_php_versions); }
phpset() { local ver=${1:?Usage: phpset <version>}; sudo update-alternatives --set php "/usr/bin/php${ver}" && sudo a2enconf "php${ver}-fpm" && sudo service apache2 reload; }
alias phpset56='phpset 5.6'
alias phpset74='phpset 7.4'
alias phpset81='phpset 8.1'
alias phpset82='phpset 8.2'
alias phpset83='phpset 8.3'
alias phpset84='phpset 8.4'
alias phpset85='phpset 8.5'

# Service controls. Config tests run before restarts/reloads where supported.
alias redisboot='sudo service redis-server restart'
alias redisconf='sudo cp /etc/redis/redis.conf /etc/redis/redis.conf.bak && sudo nano /etc/redis/redis.conf'
alias redisedit='sudo nano /etc/redis/redis.conf'
alias redisstat='sudo service redis-server status'
alias redisstop='sudo service redis-server stop'
alias redistail='sudo tail -f /var/log/redis/redis-server.log'
alias ngxboot='sudo nginx -t && sudo service nginx restart'
alias ngxconf='sudo cp /etc/nginx/sites-available/localhost.conf /etc/nginx/sites-available/localhost.conf.bak && sudo nano /etc/nginx/sites-available/localhost.conf'
alias ngxedit='sudo nano /etc/nginx/sites-available/localhost.conf'
alias ngxload='sudo nginx -t && sudo service nginx reload'
alias ngxstat='sudo service nginx status'
alias ngxstop='sudo service nginx stop'
alias ngxtail='sudo tail -f /var/log/nginx/*.log'
alias ap2boot='sudo apache2ctl configtest && sudo service apache2 restart'
alias ap2conf='sudo cp /etc/apache2/sites-available/localhost.conf /etc/apache2/sites-available/localhost.conf.bak && sudo nano /etc/apache2/sites-available/localhost.conf'
alias ap2edit='sudo nano /etc/apache2/sites-available/localhost.conf'
alias ap2load='sudo apache2ctl configtest && sudo service apache2 reload'
alias ap2stat='sudo service apache2 status'
alias ap2stop='sudo service apache2 stop'
alias ap2tail='sudo tail -f /var/log/apache2/*.log'
alias mdbboot='sudo service mariadb restart'
alias mdbconf='sudo cp /etc/mysql/mariadb.conf.d/99-wsl2php.cnf /etc/mysql/mariadb.conf.d/99-wsl2php.cnf.bak && sudo nano /etc/mysql/mariadb.conf.d/99-wsl2php.cnf'
alias mdbedit='sudo nano /etc/mysql/mariadb.conf.d/99-wsl2php.cnf'
alias mdbstat='sudo service mariadb status'
alias mdbstop='sudo service mariadb stop'
alias mdbtail='sudo tail -f /var/log/mysql/*.log'
alias mdbtune='mysqltuner'
alias phptail='sudo tail -f /var/log/php*.log'

# Database helpers retained from serverold.
mdbexp() {
  local database=${1:-}
  local query="SHOW DATABASES WHERE \`Database\`"
  local param
  if [[ -n "$database" ]]; then
    param=" IN ('${database//\'/\'\'}')"
  else
    param=" NOT REGEXP '(^mysql|_schema$|sys)'"
  fi
  for database in $(sudo mariadb -e "$query$param" | awk 'NR!=1 {print $1}'); do
    echo "Dumping $database..."
    if command -v pigz >/dev/null 2>&1; then
      sudo mariadb-dump --single-transaction --events --routines --flush-privileges "$database" |
        sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' |
        sed -e "s/\`$database\`\.//g" | pigz -9 >"$database.sql.gz"
    else
      sudo mariadb-dump --single-transaction --events --routines --flush-privileges "$database" |
        sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' |
        sed -e "s/\`$database\`\.//g" | gzip -9 >"$database.sql.gz"
    fi
  done
}
mdbimp() {
  local file=${1:-} database=${2:-}
  [[ -n "$file" && -n "$database" ]] || { echo 'Usage: mdbimp <file.sql[.gz]> <database>'; return 1; }
  echo "Importing $file to $database..."
  if [[ "$file" == *.sql.gz ]]; then
    gunzip -c "$file" | sudo mariadb "$database"
  else
    sudo mariadb "$database" <"$file"
  fi
}

# Cleanup utilities retained for compatibility with serverold.
aptclear() { sudo apt autoremove --purge -y && sudo apt clean && sudo apt autoclean && sudo rm -rf /var/lib/apt/lists/*; }
logclear() { sudo find /var/log -type f \( -name '*.gz' -o -regex '.*\.[0-9]+$' \) -delete 2>/dev/null; sudo find /var/log -type f -name '*.log' -exec truncate -s 0 {} + 2>/dev/null; sudo journalctl --vacuum-time=7d >/dev/null 2>&1; : >"$HOME/.bash_history"; }
tmpclear() { sudo rm -rf /tmp/* /var/tmp/* "$HOME/.cache"/* 2>/dev/null || true; }
allclear() { aptclear && logclear && tmpclear; }

# Stack shortcuts. lempx is the safe default; lampx/leampx remain for legacy use.
alias lampx='phpboot && ap2boot && mdbboot && redisboot'
alias lempx='phpboot && ngxboot && mdbboot && redisboot'
alias leampx='phpboot && ngxboot && ap2boot && mdbboot && redisboot'

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='cd ~'
alias l='ls -alhF'
