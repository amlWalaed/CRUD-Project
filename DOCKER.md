# Docker Setup Guide

This project is containerized using Docker and Docker Compose. This guide will help you get started with running the application in containers.

## Prerequisites

- Docker Desktop (or Docker Engine + Docker Compose)
- Git

## Quick Start

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone <repository-url>
   cd CRUD-Project
   ```

2. **Create environment file**:
   ```bash
   cp .env.example .env
   ```

3. **Update `.env` file** with Docker-specific settings:
   ```env
   APP_ENV=local
   APP_DEBUG=true
   DB_CONNECTION=mysql
   DB_HOST=mysql
   DB_PORT=3306
   DB_DATABASE=crud_db
   DB_USERNAME=crud_user
   DB_PASSWORD=crud_password
   REDIS_HOST=redis
   REDIS_PORT=6379
   ```

4. **Build and start containers**:
   ```bash
   docker-compose up -d --build
   ```

5. **Install dependencies and setup Laravel**:
   ```bash
   # Install PHP dependencies (if not already done)
   docker-compose exec app composer install

   # Install Node dependencies (if not already done)
   docker-compose exec app npm install

   # Generate application key
   docker-compose exec app php artisan key:generate

   # Run migrations
   docker-compose exec app php artisan migrate

   # (Optional) Seed database
   docker-compose exec app php artisan db:seed
   ```

6. **Access the application**:
   - Application: http://localhost:8080
   - The application will be served through Nginx

## Docker Services

The `docker-compose.yml` file defines the following services:

- **app**: Laravel PHP-FPM application
- **nginx**: Nginx web server
- **mysql**: MySQL 8.0 database
- **redis**: Redis cache/session store

## Useful Commands

### Start containers
```bash
docker-compose up -d
```

### Stop containers
```bash
docker-compose down
```

### View logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f mysql
```

### Execute commands in containers
```bash
# Run Artisan commands
docker-compose exec app php artisan <command>

# Run Composer commands
docker-compose exec app composer <command>

# Run NPM commands
docker-compose exec app npm <command>

# Access container shell
docker-compose exec app sh
```

### Rebuild containers
```bash
docker-compose up -d --build
```

### Clear Laravel caches
```bash
docker-compose exec app php artisan cache:clear
docker-compose exec app php artisan config:clear
docker-compose exec app php artisan route:clear
docker-compose exec app php artisan view:clear
```

### Run migrations
```bash
docker-compose exec app php artisan migrate
```

### Run tests
```bash
docker-compose exec app php artisan test
```

## Development Workflow

1. **Make code changes** - Your code is mounted as a volume, so changes are reflected immediately
2. **Frontend changes** - For Vue.js changes, you may need to rebuild assets:
   ```bash
   docker-compose exec app npm run build
   ```
   Or use Vite dev server (if configured):
   ```bash
   docker-compose exec app npm run dev
   ```

3. **Database changes** - After creating migrations:
   ```bash
   docker-compose exec app php artisan migrate
   ```

## Production Build

To build for production:

```bash
docker-compose -f docker-compose.yml build --target production
```

## Troubleshooting

### Permission issues
If you encounter permission issues with storage or cache:
```bash
docker-compose exec app chown -R www-data:www-data storage bootstrap/cache
docker-compose exec app chmod -R 755 storage bootstrap/cache
```

### Database connection issues
Ensure the database service is healthy:
```bash
docker-compose ps
```

Check database logs:
```bash
docker-compose logs mysql
```

### Clear everything and start fresh
```bash
docker-compose down -v
docker-compose up -d --build
```

## Environment Variables

You can customize the setup by creating a `.env` file or setting environment variables:

- `APP_PORT`: Port for the application (default: 8000)
- `NGINX_PORT`: Port for Nginx (default: 8080)
- `DB_DATABASE`: Database name (default: crud_db)
- `DB_USERNAME`: Database user (default: crud_user)
- `DB_PASSWORD`: Database password (default: crud_password)
- `DB_PORT`: Database port (default: 3306)
- `REDIS_PORT`: Redis port (default: 6379)

## Volumes

Data is persisted in Docker volumes:
- `mysql_data`: MySQL database data
- `redis_data`: Redis data

To remove all data:
```bash
docker-compose down -v
```

