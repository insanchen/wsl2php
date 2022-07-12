-- Execute mysql_secure_installation
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;

-- phpMyAdmin
DROP USER IF EXISTS phpmyadmin;
DROP DATABASE IF EXISTS phpmyadmin;
CREATE DATABASE phpmyadmin DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
GRANT ALL ON phpmyadmin.* TO 'phpmyadmin'@'localhost' IDENTIFIED BY 'phpmyadmin';

-- Flush privileges
FLUSH PRIVILEGES;
