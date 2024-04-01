#!/bin/bash

clear


# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to display a fancy loading bar
loading_bar() {
    local duration=$1
    local columns=$(tput cols)
    local fill=$(printf "%0.s=" $(seq 1 $columns))
    local i

    for ((i=0; i<=$columns; i++)); do
        echo -ne "\r[${fill:0:$i}] $((100 * $i / $columns))%"
        sleep $duration
    done
    echo -ne "\n"
}

# Function to display an error message
display_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# Function to display a success message
display_success() {
    echo -e "${GREEN}$1${NC}"
}

# Start installation process
echo "PunBB Installation Script"
echo "-------------------------"
echo "This script will install PunBB on your Raspberry Pi."
read -p "Press Enter to continue or Ctrl+C to cancel."

# Update and upgrade the system
echo -e "\nUpdating and upgrading the system..."
sudo apt update && sudo apt upgrade -y > /dev/null 2>&1
loading_bar 0.1
display_success "System updated and upgraded successfully."

# Install necessary packages
echo -e "\nInstalling necessary packages..."
sudo apt install -y apache2 php8.2 php8.2-sqlite3 sqlite3 > /dev/null 2>&1
loading_bar 0.1
display_success "Packages installed successfully."

# Download PunBB
echo -e "\nDownloading PunBB..."
wget https://github.com/punbb/punbb/archive/master.tar.gz -q --show-progress
tar -xzf master.tar.gz > /dev/null 2>&1
loading_bar 0.1
display_success "PunBB downloaded and extracted successfully."

# Move PunBB to web directory
echo -e "\nMoving PunBB to web directory..."
sudo mv punbb-master /var/www/html/punbb
loading_bar 0.1
display_success "PunBB moved to web directory successfully."

# Set permissions
echo -e "\nSetting permissions..."
sudo chown -R www-data:www-data /var/www/html/punbb
sudo chmod -R 755 /var/www/html/punbb
loading_bar 0.1
display_success "Permissions set successfully."

# Create SQLite database
echo -e "\nCreating SQLite database... (press control+c if you hav waited 120 seconds)"
cd /var/www/html/punbb
sqlite3 punbb.db > /dev/null 2>&1
loading_bar 0.1
display_success "SQLite database created successfully."

# Configure Apache for PunBB
echo -e "\nConfiguring Apache for PunBB..."
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/punbb.conf
sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/punbb/' /etc/apache2/sites-available/punbb.conf
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/punbb.conf
loading_bar 0.1
display_success "Apache configured successfully."

# Enable the new configuration
echo -e "\nEnabling Apache configuration..."
sudo a2ensite punbb.conf > /dev/null 2>&1
loading_bar 0.1
display_success "Apache configuration enabled successfully."

# Enable required Apache modules
echo -e "\nEnabling required Apache modules..."
sudo a2enmod rewrite > /dev/null 2>&1
loading_bar 0.1
display_success "Apache modules enabled successfully."

# Restart Apache
echo -e "\nRestarting Apache..."
sudo systemctl restart apache2 > /dev/null 2>&1
loading_bar 0.1
display_success "Apache restarted successfully."

# Final message
echo -e "\nPunBB installation completed successfully!"
echo -e "You can now access PunBB at ${GREEN}http://$(hostname -I | awk '{print $1}')/punbb${NC}"
