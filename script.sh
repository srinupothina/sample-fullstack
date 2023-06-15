#!/bin/bash

# Function to check if a package is installed
is_package_installed() {
    dpkg-query -W "$1" > /dev/null 2>&1
}

# Check if Maven is installed
if ! is_package_installed maven; then
    echo "Maven is not installed. Installing..."
    sudo apt update
    sudo apt install -y maven
else
    echo "Maven is already installed. Skipping installation."
fi

# Check if Java 17 is installed
if ! is_package_installed openjdk-17-jdk; then
    echo "Java 17 is not installed. Installing..."
    sudo apt update
    sudo apt install -y openjdk-17-jdk
else
    echo "Java 17 is already installed. Skipping installation."
fi

# Check if Docker is installed
if ! is_package_installed docker-ce; then
    echo "Docker is not installed. Installing..."
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
else
    echo "Docker is already installed. Skipping installation."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose > /dev/null 2>&1; then
    echo "Docker Compose is not installed. Installing..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed. Skipping installation."
fi

# Start PostgreSQL container
sudo docker run -d --name postgres-db -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres

# Wait for the PostgreSQL container to start
echo "Waiting for the PostgreSQL container to start..."
sleep 10

# Connect to PostgreSQL server
# sudo docker exec -it postgres-db psql -U postgres

# Create the database "themoviedb"
sudo docker exec postgres-db psql -U postgres -c "CREATE DATABASE themoviedb;"
