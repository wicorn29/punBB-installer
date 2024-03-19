#!/bin/bash

# Update and upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install Apache, PHP, and SQLite
sudo apt-get install -y apache2 php libapache2-mod-php php-sqlite3 unzip

# Enable Apache modules
sudo a2enmod rewrite
sudo a2enmod headers
sudo service apache2 restart

# Download and extract PunBB
cd /var/www/html
sudo wget https://punbb.informer.com/download/punbb-1.4.6.zip
sudo unzip punbb-1.4.6.zip
sudo mv punbb-1.4.6/* .
sudo rm -r punbb-1.4.6
sudo chown -R www-data:www-data /var/www/html

# Configure Apache virtual host
sudo tee /etc/apache2/sites-available/punbb.conf > /dev/null <<EOL
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    <Directory /var/www/html/>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOL

# Enable the virtual host
sudo a2ensite punbb.conf

# Restart Apache
sudo service apache2 restart

echo "PunBB installation script completed."
