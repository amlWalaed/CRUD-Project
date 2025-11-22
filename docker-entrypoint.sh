#!/bin/sh

set -e

echo "Waiting for database connection..."
# Wait for MySQL to be ready
until nc -z mysql 3306; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is up - executing commands"

# Generate application key if not set (check if key exists in .env)
if ! grep -q "APP_KEY=base64:" .env 2>/dev/null; then
    echo "Generating application key..."
    php artisan key:generate --force || true
fi

# Run migrations (only if APP_ENV is set)
if [ -n "$APP_ENV" ]; then
    echo "Running migrations..."
    php artisan migrate --force || true
fi

# Clear caches
php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

# Cache config for production
if [ "$APP_ENV" = "production" ]; then
    php artisan config:cache || true
    php artisan route:cache || true
    php artisan view:cache || true
fi

# Start PHP-FPM
exec php-fpm

