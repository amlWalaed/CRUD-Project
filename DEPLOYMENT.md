# Deployment Guide for Ubuntu on EC2

This guide will help you deploy your Laravel CRUD Project on an Ubuntu EC2 instance.

## Prerequisites

-   An AWS EC2 instance running Ubuntu 20.04 or 22.04
-   SSH access to your EC2 instance
-   A domain name (optional, but recommended)
-   Basic knowledge of Linux commands

## Step 1: Initial EC2 Setup

### 1.1 Connect to your EC2 instance

```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

### 1.2 Update the system

```bash
sudo apt update && sudo apt upgrade -y
```

## Step 2: Run the Deployment Script

### 2.1 Upload the deployment script

Copy the `deploy.sh` script to your EC2 instance:

```bash
# From your local machine
scp -i your-key.pem deploy.sh ubuntu@your-ec2-ip:/home/ubuntu/
```

### 2.2 Make it executable and run

```bash
# On EC2 instance
chmod +x deploy.sh
sudo ./deploy.sh
```

**Note:** The script will install all required packages. You'll need to manually:

-   Clone your repository or upload your code
-   Configure your `.env` file
-   Set up the database

## Step 3: Deploy Your Application Code

### 3.1 Clone your repository

```bash
cd /var/www
sudo git clone https://github.com/yourusername/CRUD-Project.git crud-project
sudo chown -R www-data:www-data crud-project
```

Or if you're using SSH:

```bash
cd /var/www
sudo git clone git@github.com:yourusername/CRUD-Project.git crud-project
sudo chown -R www-data:www-data crud-project
```

### 3.2 Install dependencies

```bash
cd /var/www/crud-project
sudo -u www-data composer install --no-dev --optimize-autoloader
sudo -u www-data npm install
sudo -u www-data npm run build
```

## Step 4: Configure Environment

### 4.1 Create `.env` file

```bash
cd /var/www/crud-project
sudo -u www-data cp .env.example .env
sudo -u www-data php artisan key:generate
```

### 4.2 Edit `.env` file

```bash
sudo nano /var/www/crud-project/.env
```

Update the following important variables:

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=crud_project
DB_USERNAME=crud_user
DB_PASSWORD=your_secure_password

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
```

## Step 5: Set Up Database

### 5.1 Secure MySQL installation

```bash
sudo mysql_secure_installation
```

### 5.2 Create database and user

```bash
sudo mysql -u root -p
```

Then in MySQL:

```sql
CREATE DATABASE crud_project CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'crud_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON crud_project.* TO 'crud_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 5.3 Run migrations

```bash
cd /var/www/crud-project
sudo -u www-data php artisan migrate --force
```

## Step 6: Configure Nginx

### 6.1 Copy the production Nginx configuration

```bash
sudo cp nginx-production.conf /etc/nginx/sites-available/crud-project
```

### 6.2 Edit the configuration

```bash
sudo nano /etc/nginx/sites-available/crud-project
```

Update `server_name` with your domain:

```nginx
server_name your-domain.com www.your-domain.com;
```

### 6.3 Enable the site

```bash
sudo ln -s /etc/nginx/sites-available/crud-project /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default  # Remove default site if exists
```

### 6.4 Test and reload Nginx

```bash
sudo nginx -t
sudo systemctl reload nginx
```

## Step 7: Set Up SSL Certificate (Optional but Recommended)

### 7.1 Install Certbot (if not already installed)

```bash
sudo apt install certbot python3-certbot-nginx -y
```

### 7.2 Obtain SSL certificate

```bash
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

Follow the prompts. Certbot will automatically configure Nginx for HTTPS.

## Step 8: Set Permissions

```bash
cd /var/www/crud-project
sudo chown -R www-data:www-data .
sudo chmod -R 755 .
sudo chmod -R 775 storage bootstrap/cache
```

## Step 9: Optimize Laravel for Production

```bash
cd /var/www/crud-project
sudo -u www-data php artisan config:cache
sudo -u www-data php artisan route:cache
sudo -u www-data php artisan view:cache
```

## Step 10: Configure Firewall

```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
```

## Step 11: Set Up Queue Worker (if using queues)

### 11.1 Create supervisor configuration

```bash
sudo nano /etc/supervisor/conf.d/crud-project-worker.conf
```

Add:

```ini
[program:crud-project-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/crud-project/artisan queue:work redis --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/www/crud-project/storage/logs/worker.log
stopwaitsecs=3600
```

### 11.2 Start supervisor

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start crud-project-worker:*
```

## Step 12: Set Up Automated Backups (Recommended)

Create a backup script:

```bash
sudo nano /usr/local/bin/backup-crud-project.sh
```

Add:

```bash
#!/bin/bash
BACKUP_DIR="/backups/crud-project"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Backup database
mysqldump -u crud_user -p'your_password' crud_project > $BACKUP_DIR/db_$DATE.sql

# Backup files
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/crud-project

# Keep only last 7 days
find $BACKUP_DIR -type f -mtime +7 -delete
```

Make it executable:

```bash
sudo chmod +x /usr/local/bin/backup-crud-project.sh
```

Add to crontab:

```bash
sudo crontab -e
```

Add:

```
0 2 * * * /usr/local/bin/backup-crud-project.sh
```

## Troubleshooting

### Check Nginx logs

```bash
sudo tail -f /var/log/nginx/crud-project-error.log
```

### Check Laravel logs

```bash
sudo tail -f /var/www/crud-project/storage/logs/laravel.log
```

### Check PHP-FPM status

```bash
sudo systemctl status php8.1-fpm
```

### Restart services

```bash
sudo systemctl restart nginx
sudo systemctl restart php8.1-fpm
sudo systemctl restart redis-server
sudo systemctl restart mysql
```

### Clear Laravel caches

```bash
cd /var/www/crud-project
sudo -u www-data php artisan cache:clear
sudo -u www-data php artisan config:clear
sudo -u www-data php artisan route:clear
sudo -u www-data php artisan view:clear
```

## Security Checklist

-   [ ] Change default SSH port (optional)
-   [ ] Set up SSH key authentication only
-   [ ] Configure firewall (UFW)
-   [ ] Set strong database passwords
-   [ ] Enable SSL/HTTPS
-   [ ] Set `APP_DEBUG=false` in production
-   [ ] Regularly update system packages
-   [ ] Set up automated backups
-   [ ] Configure log rotation
-   [ ] Review file permissions

## Maintenance Commands

### Update application code

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

### Monitor application

```bash
# Check disk space
df -h

# Check memory
free -h

# Check running processes
htop

# Check Nginx status
sudo systemctl status nginx
```

## Additional Resources

-   [Laravel Deployment Documentation](https://laravel.com/docs/deployment)
-   [Nginx Configuration Guide](https://nginx.org/en/docs/)
-   [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
