#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y apache2 php8.2 php8.2-sqlite3 sqlite3

# Download PunBB
wget https://github.com/punbb/punbb/archive/master.tar.gz
tar -xzf master.tar.gz

# Move PunBB to web directory
sudo mv punbb-master /var/www/html/punbb

# Set permissions
sudo chown -R www-data:www-data /var/www/html/punbb
sudo chmod -R 755 /var/www/html/punbb

# Create SQLite database
cd /var/www/html/punbb
sqlite3 punbb.db

# Configure Apache for PunBB
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/punbb.conf
sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/punbb/' /etc/apache2/sites-available/punbb.conf
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/punbb.conf

# Enable the new configuration
sudo a2ensite punbb.conf

# Enable required Apache modules
sudo a2enmod rewrite

# Restart Apache
sudo systemctl restart apache2

echo "PunBB installation completed successfully!"
echo "You can now access PunBB at http://your_raspberry_pi_ip/punbb"

