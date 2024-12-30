#!/bin/bash

# Change to the project directory
cd "$(dirname "$0")" || exit

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or with sudo"
  exit
fi

# Stop any running containers
docker compose -f docker-compose.dev.yml down

docker compose -f docker-compose.dev.yml build --no-cache

# Build and start the containers
docker compose -f docker-compose.dev.yml up -d

# Change permissions for the backend directory
chown -R "$SUDO_USER":"$SUDO_USER" backend
chmod -R 755 backend

# Change permissions for the frontend directory
chown -R "$SUDO_USER":"$SUDO_USER" frontend
chmod -R 755 frontend

# Run database migrations
docker compose -f docker-compose.dev.yml exec backend npx prisma migrate dev

echo "Development environment is up and running!"
