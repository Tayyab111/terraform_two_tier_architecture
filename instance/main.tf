resource "aws_instance" "my_ec2" {
  ami = "ami-0a95d2cc973f39afc"  # Note: if you are using amazon-linux then use amazon-linux-2 not an amazon-linux-2023
  instance_type = "t2.micro"
  key_name = "terra"
  subnet_id = var.public_subnet_id[0]
  associate_public_ip_address = true
  vpc_security_group_ids = [ var.sg_id ]
  tags = merge(var.tags , {Name = "test_ec2"})

  user_data = <<EOF
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
        sed -i "s/$cfg['Servers'][$i]['host'] = 'localhost'/$cfg['Servers'][$i]['host'] = 'usama-database.cozzdxzyun2d.us-east-2.rds.amazonaws.com'/g" /var/www/html/phpMyAdmin/config.inc.php
        cd ..
        sudo yum update -y
        sudo yum install -y jq
        cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
        dbname=${var.db_name}
        username=${var.master_username}
        password=${var.master_password}
        db_endpoint=${var.cluster_endpoint}
        sed -i "s/define( 'DB_NAME', 'database_name_here' )/define( 'DB_NAME', '$dbname' )/g" /var/www/html/wp-config.php
        sed -i "s/define( 'DB_USER', 'username_here' )/define( 'DB_USER', '$username' )/g" /var/www/html/wp-config.php
        sed -i "s/define( 'DB_PASSWORD', 'password_here' )/define( 'DB_PASSWORD', '$password' )/g" /var/www/html/wp-config.php
        sed -i "s/define( 'DB_HOST', 'localhost' )/define( 'DB_HOST', '$db_endpoint' )/g" /var/www/html/wp-config.php

    EOF
  }
#  resource "aws_key_pair" "my_key" {
#    key_name   = "terraa"
#    public_key = file("/home/tayab/Downloads/terra.pem")
#  }
