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

# Display instructions
echo "=========================================="
echo "          Voice App Instructions          "
echo "=========================================="
echo "To start the server:"
echo "  ./run-voice-app.sh"
echo ""
echo "To stop the server:"
echo "  docker-compose -f docker-compose.prod.yml down"
echo ""
echo "To access the application:"
echo "  http://localhost:5000"
echo "=========================================="
echo ""

# Prompt user to continue
read -p "Press Enter to start the Voice app, or Ctrl+C to exit..."

# Run the Voice app using Docker Compose
echo "Starting the Voice app..."
docker-compose -f docker-compose.prod.yml up -d

# Function to open browser based on OS
open_browser() {
    case "$(uname -s)" in
        Darwin*)  open "http://localhost:5000" ;;
        Linux*)   xdg-open "http://localhost:5000" ;;
        MINGW*|CYGWIN*)  start "http://localhost:5000" ;;
    esac
}

# Attempt to open browser
if command_exists open || command_exists xdg-open || command_exists start; then
    echo "Attempting to open browser..."
    open_browser
else
    echo "Could not automatically open browser. Please navigate to http://localhost:5000 in your web browser."
fi

echo ""
echo "Voice app is now running."
echo "To stop the server, use: docker-compose -f docker-compose.prod.yml down"