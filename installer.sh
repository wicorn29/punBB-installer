#!/bin/bash
echo "Please wait, running sudo stuff..."

# Update and upgrade the system
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1

echo "Installing WebSocket jazz..."

# Install Apache, PHP, and SQLite
sudo apt-get install -y apache2 php libapache2-mod-php php-sqlite3 unzip > /dev/null 2>&1

echo "Making it work on boot..."

# Enable Apache modules
sudo a2enmod rewrite > /dev/null 2>&1
sudo a2enmod headers > /dev/null 2>&1
sudo service apache2 restart > /dev/null 2>&1
echo "DOWNLOADING PUNBB :)"

# Download and extract PunBB
cd /var/www/html > /dev/null 2>&1
sudo wget https://punbb.informer.com/download/punbb-1.4.6.zip > /dev/null 2>&1

echo "Unzip punbb i think that's what it's doing"

sudo unzip punbb-1.4.6.zip > /dev/null 2>&1
sudo mv punbb-1.4.6/* . > /dev/null 2>&1
sudo rm -r punbb-1.4.6 > /dev/null 2>&1
sudo chown -R www-data:www-data /var/www/html > /dev/null 2>&1

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

echo "Cleaning up some junk..."

# Enable the virtual host
sudo a2ensite punbb.conf > /dev/null 2>&1
# Delete the default html so it goes to php
sudo rm /var/www/html/index.html > /dev/null 2>&1

echo "Final stage"

# Restart Apache
sudo service apache2 restart > /dev/null 2>&1

echo "PunBB installation script completed."

#!/bin/bash

# Prompt the user
echo "Do you want to reboot to apply changes? (y/n)"
read -r response

# Check the response
if [[ "$response" = "y" || "$response" = "Y" ]]; then
    echo "Rebooting now..."
    sudo reboot
else
    echo "Reboot canceled. Please reboot as soon as possible or things will not go right"
fi

