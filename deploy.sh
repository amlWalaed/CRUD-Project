#!/bin/bash

# Laravel CRUD Project - Ubuntu EC2 Deployment Script
# This script sets up the environment and deploys the application

set -e

echo "🚀 Starting deployment process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="crud-project"
APP_DIR="/var/www/${APP_NAME}"
APP_USER="www-data"
PHP_VERSION="8.1"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${GREEN}Step 1: Updating system packages...${NC}"
# Clear apt cache to fix potential mirror sync issues
apt-get clean
rm -rf /var/lib/apt/lists/*

# Retry update with error handling
if ! apt-get update; then
    echo -e "${YELLOW}First update attempt failed, waiting 10 seconds and retrying...${NC}"
    sleep 10
    apt-get update || {
        echo -e "${YELLOW}Still having issues. Trying with fix-missing flag...${NC}"
        apt-get update --fix-missing
    }
fi

apt-get upgrade -y

echo -e "${GREEN}Step 2: Installing required packages...${NC}"
apt-get install -y \
    software-properties-common \
    curl \
    git \
    unzip \
    nginx \
    mysql-server \
    redis-server \
    supervisor \
    certbot \
    python3-certbot-nginx

echo -e "${GREEN}Step 3: Installing PHP and extensions...${NC}"
add-apt-repository -y ppa:ondrej/php
apt-get update
apt-get install -y \
    php${PHP_VERSION} \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-bcmath

echo -e "${GREEN}Step 4: Installing Node.js and npm...${NC}"
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

echo -e "${GREEN}Step 5: Installing Composer...${NC}"
if [ ! -f /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    chmod +x /usr/local/bin/composer
fi

echo -e "${GREEN}Step 6: Creating application directory...${NC}"
mkdir -p ${APP_DIR}
chown -R ${APP_USER}:${APP_USER} ${APP_DIR}

echo -e "${GREEN}Step 7: Setting up application files...${NC}"
echo -e "${YELLOW}Note: You need to clone your repository or copy files to ${APP_DIR}${NC}"
echo -e "${YELLOW}Example: git clone https://github.com/yourusername/CRUD-Project.git ${APP_DIR}${NC}"

# If files are already in the directory, proceed with setup
if [ -f "${APP_DIR}/composer.json" ]; then
    cd ${APP_DIR}

    echo -e "${GREEN}Installing PHP dependencies...${NC}"
    sudo -u ${APP_USER} composer install --no-dev --optimize-autoloader

    echo -e "${GREEN}Installing Node.js dependencies...${NC}"
    sudo -u ${APP_USER} npm install

    echo -e "${GREEN}Building frontend assets...${NC}"
    sudo -u ${APP_USER} npm run build

    echo -e "${GREEN}Setting up environment file...${NC}"
    if [ ! -f .env ]; then
        if [ -f .env.example ]; then
            cp .env.example .env
            echo -e "${YELLOW}Please edit .env file with your configuration${NC}"
        else
            echo -e "${YELLOW}Creating basic .env file...${NC}"
            cat > .env << EOF
APP_NAME=Laravel
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=http://localhost

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=${APP_NAME}
DB_USERNAME=${APP_NAME}_user
DB_PASSWORD=

BROADCAST_DRIVER=log
CACHE_DRIVER=redis
FILESYSTEM_DISK=local
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis
SESSION_LIFETIME=120

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=mailpit
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
MAIL_FROM_ADDRESS="hello@example.com"
MAIL_FROM_NAME="${APP_NAME}"
EOF
        fi
        echo -e "${YELLOW}Generating application key...${NC}"
        sudo -u ${APP_USER} php artisan key:generate
    fi

    echo -e "${GREEN}Setting permissions...${NC}"
    chown -R ${APP_USER}:${APP_USER} ${APP_DIR}
    chmod -R 755 ${APP_DIR}
    chmod -R 775 ${APP_DIR}/storage
    chmod -R 775 ${APP_DIR}/bootstrap/cache

    echo -e "${GREEN}Running database migrations...${NC}"
    echo -e "${YELLOW}Make sure your database is configured in .env before running migrations${NC}"
    read -p "Run migrations now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo -u ${APP_USER} php artisan migrate --force
    fi

    echo -e "${GREEN}Optimizing Laravel...${NC}"
    sudo -u ${APP_USER} php artisan config:cache
    sudo -u ${APP_USER} php artisan route:cache
    sudo -u ${APP_USER} php artisan view:cache
fi

echo -e "${GREEN}Step 8: Configuring PHP-FPM...${NC}"
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/${PHP_VERSION}/fpm/php.ini
systemctl restart php${PHP_VERSION}-fpm
systemctl enable php${PHP_VERSION}-fpm

echo -e "${GREEN}Step 9: Configuring Nginx...${NC}"
echo -e "${YELLOW}Nginx configuration will be created in /etc/nginx/sites-available/${APP_NAME}${NC}"
echo -e "${YELLOW}You need to manually configure it or use the provided nginx config file${NC}"

echo -e "${GREEN}Step 10: Setting up MySQL...${NC}"
echo -e "${YELLOW}Please secure your MySQL installation:${NC}"
echo -e "${YELLOW}Run: mysql_secure_installation${NC}"

echo -e "${GREEN}Step 11: Configuring Redis...${NC}"
systemctl enable redis-server
systemctl restart redis-server

echo -e "${GREEN}Step 12: Setting up firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 'Nginx Full'
    ufw allow OpenSSH
    echo -e "${YELLOW}Review firewall rules and enable with: ufw enable${NC}"
fi

echo -e "${GREEN}✅ Deployment script completed!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "1. Configure your .env file in ${APP_DIR}"
echo -e "2. Set up your database and run migrations"
echo -e "3. Configure Nginx (use the provided nginx config)"
echo -e "4. Set up SSL certificate with certbot"
echo -e "5. Test your application"

