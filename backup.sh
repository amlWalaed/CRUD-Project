#!/bin/bash

# Backup script for Laravel CRUD Project
# Run this script daily via cron

set -e

# Configuration
APP_DIR="/var/www/crud-project"
BACKUP_DIR="/backups/crud-project"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7

# Database credentials (read from .env or set here)
DB_NAME="crud_project"
DB_USER="crud_user"
DB_PASS=""  # Set this or read from .env

# Create backup directory
mkdir -p $BACKUP_DIR

echo "Starting backup at $(date)"

# Backup database
if [ -n "$DB_PASS" ]; then
    mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_$DATE.sql
else
    # Try to read from .env
    if [ -f "$APP_DIR/.env" ]; then
        DB_PASS=$(grep DB_PASSWORD $APP_DIR/.env | cut -d '=' -f2 | tr -d ' ')
        mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_$DATE.sql
    else
        echo "Warning: Could not find database password. Skipping database backup."
    fi
fi

# Compress database backup
if [ -f "$BACKUP_DIR/db_$DATE.sql" ]; then
    gzip $BACKUP_DIR/db_$DATE.sql
    echo "Database backup created: db_$DATE.sql.gz"
fi

# Backup application files (excluding vendor, node_modules, etc.)
tar -czf $BACKUP_DIR/files_$DATE.tar.gz \
    --exclude="$APP_DIR/vendor" \
    --exclude="$APP_DIR/node_modules" \
    --exclude="$APP_DIR/.git" \
    --exclude="$APP_DIR/storage/logs/*" \
    --exclude="$APP_DIR/storage/framework/cache/*" \
    --exclude="$APP_DIR/storage/framework/sessions/*" \
    --exclude="$APP_DIR/storage/framework/views/*" \
    $APP_DIR

echo "Files backup created: files_$DATE.tar.gz"

# Remove old backups (older than RETENTION_DAYS)
find $BACKUP_DIR -type f -mtime +$RETENTION_DAYS -delete

echo "Backup completed at $(date)"
echo "Backup location: $BACKUP_DIR"

