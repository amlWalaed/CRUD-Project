# Quick Start Deployment Guide

## TL;DR - Fast Deployment Steps

### 1. Upload files to EC2

```bash
# From your local machine
scp -i your-key.pem deploy.sh nginx-production.conf ubuntu@your-ec2-ip:/home/ubuntu/
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### 2. Run deployment script

```bash
chmod +x deploy.sh
sudo ./deploy.sh
```

### 3. Clone your repository

```bash
cd /var/www
sudo git clone https://github.com/yourusername/CRUD-Project.git crud-project
sudo chown -R www-data:www-data crud-project
cd crud-project
```

### 4. Install dependencies

```bash
sudo -u www-data composer install --no-dev --optimize-autoloader
sudo -u www-data npm install
sudo -u www-data npm run build
```

### 5. Configure environment

```bash
sudo -u www-data cp .env.example .env
sudo -u www-data php artisan key:generate
sudo nano .env  # Edit with your settings
```

### 6. Set up database

```bash
sudo mysql -u root -p
```

```sql
CREATE DATABASE crud_project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'crud_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON crud_project.* TO 'crud_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

```bash
sudo -u www-data php artisan migrate --force
```

### 7. Configure Nginx

```bash
sudo cp /home/ubuntu/nginx-production.conf /etc/nginx/sites-available/crud-project
sudo nano /etc/nginx/sites-available/crud-project  # Update server_name
sudo ln -s /etc/nginx/sites-available/crud-project /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

### 8. Set permissions

```bash
cd /var/www/crud-project
sudo chown -R www-data:www-data .
sudo chmod -R 755 .
sudo chmod -R 775 storage bootstrap/cache
```

### 9. Optimize Laravel

```bash
sudo -u www-data php artisan config:cache
sudo -u www-data php artisan route:cache
sudo -u www-data php artisan view:cache
```

### 10. Set up SSL (optional)

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

## Common Commands

### Restart services

```bash
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
sudo systemctl restart redis-server
sudo systemctl restart mysql
```

### View logs

```bash
# Nginx
sudo tail -f /var/log/nginx/crud-project-error.log

# Laravel
sudo tail -f /var/www/crud-project/storage/logs/laravel.log

# PHP-FPM
sudo tail -f /var/log/php8.1-fpm.log
```

### Clear caches

```bash
cd /var/www/crud-project
sudo -u www-data php artisan cache:clear
sudo -u www-data php artisan config:clear
sudo -u www-data php artisan route:clear
sudo -u www-data php artisan view:clear
```

### Update application

```bash
cd /var/www/crud-project
sudo -u www-data git pull
sudo -u www-data composer install --no-dev --optimize-autoloader
sudo -u www-data npm install
sudo -u www-data npm run build
sudo -u www-data php artisan migrate --force
sudo -u www-data php artisan config:cache
sudo -u www-data php artisan route:cache
sudo -u www-data php artisan view:cache
```
