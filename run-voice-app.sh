#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Docker on macOS
install_docker_mac() {
    echo "Installing Docker on macOS..."
    if command_exists brew; then
        brew install --cask docker
    else
        echo "Homebrew is not installed. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
}

# Function to install Docker on Linux
install_docker_linux() {
    echo "Installing Docker on Linux..."
    sudo apt-get update
    sudo apt-get install -y docker.io docker-compose
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER
    echo "Please log out and log back in for the group changes to take effect."
}

# Function to install Docker on Windows (using WSL2)
install_docker_windows() {
    echo "Please install Docker Desktop for Windows manually:"
    echo "1. Visit https://www.docker.com/products/docker-desktop"
    echo "2. Download and install Docker Desktop for Windows"
    echo "3. Ensure WSL2 is enabled"
    echo "4. After installation, run this script again"
    exit 1
}

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker is not installed. Installing Docker..."
    case "$(uname -s)" in
        Darwin*)    install_docker_mac ;;
        Linux*)     install_docker_linux ;;
        MINGW*|CYGWIN*) install_docker_windows ;;
        *)          echo "Unsupported operating system" && exit 1 ;;
    esac
fi

# Check if Docker Compose is installed
if ! command_exists docker-compose; then
    echo "Docker Compose is not installed. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Run the Voice app using Docker Compose
echo "Starting the Voice app..."
docker-compose -f docker-compose.prod.yml up -d

echo "Voice app is now running. Access it at http://localhost:5000"
