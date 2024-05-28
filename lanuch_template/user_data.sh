#!/bin/bash -x
yum install amazon-linux-extras httpd -y 
amazon-linux-extras install php7.2 -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz 
cp -r wordpress/* /var/www/html/
rm -rf wordpress
rm -rf latest.tar.gz
chmod -R 755 /var/www/html/*
chown -R apache:apache /var/www/html/*
cd ~
sudo yum install php-mbstring php-xml -y
sudo systemctl restart httpd
sudo systemctl restart php-fpm
cd /var/www/html
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir phpMyAdmin && tar -xvzf phpMyAdmin-latest-all-languages.tar.gz -C phpMyAdmin --strip-components 1
rm phpMyAdmin-latest-all-languages.tar.gz
cd phpMyAdmin
touch config.inc.php
mv config.sample.inc.php config.inc.php
sed -i "s/$cfg['Servers'][$i]['host'] = 'localhost'/$cfg['Servers'][$i]['host'] = 'mysql-cluster-demo.cluster-c16suim22ljx.ap-southeast-1.rds.amazonaws.com'/g" /var/www/html/phpMyAdmin/config.inc.php
cd ..
sudo yum update -y
sudo yum install -y jq
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
dbname=${dbname} # these variables are deleared in asg/mian.tf inside "template_file" liune
username=${username}
password=${password}
db_endpoint=${db_endpoint}
sed -i "s/define( 'DB_NAME', 'database_name_here' )/define( 'DB_NAME', '$dbname' )/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_USER', 'username_here' )/define( 'DB_USER', '$username' )/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_PASSWORD', 'password_here' )/define( 'DB_PASSWORD', '$password' )/g" /var/www/html/wp-config.php
sed -i "s/define( 'DB_HOST', 'localhost' )/define( 'DB_HOST', '$db_endpoint' )/g" /var/www/html/wp-config.php