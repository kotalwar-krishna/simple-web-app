#!/bin/bash

REPO_URL="https://github.com/kotalwar-krishna/simple-web-app.git"
REPO_DIR="simple-web-app"
IMAGE_NAME="krishnakotalwar/simple-web-app:latest"

# Update massage Function
update_message() {
    local message="$1"
    echo "Updating message in index.html..."
    # Backup the original file
    cp index.html index.html.bak
    
    # Use sed to update the message
    sed -i.bak "/<script>/,/<\/script>/s/document.getElementById(\"message\").innerText = \".*\";/document.getElementById(\"message\").innerText = \"${message}\";/g" index.html
    
    if [ $? -ne 0 ]; then
        echo "Failed to update the message in index.html"
        exit 1
    fi
}


if [ -d "$REPO_DIR" ]; then
    echo "Repository already exists. Pulling latest changes..."
    cd $REPO_DIR
    git pull origin main
else
    echo "Cloning the repository..."
    git clone $REPO_URL
    cd $REPO_DIR || { echo "Failed to enter repository directory"; exit 1; }
fi

read -p "Enter the new message to display on the web page: " USER_MESSAGE

update_message "$USER_MESSAGE"

echo "Committing and pushing changes to GitHub..."
git add index.html
git commit -m "Change : Update message in index.html"
git push origin main

echo "Waiting for 4 minutes so image can build using CICD..."
sleep 240

echo "Stopping and removing existing Docker container (if any)..."
docker stop simple-web-app || true
docker rm simple-web-app || true

sleep 10

# Pull the Docker image from Docker Hub
echo "Pulling Docker image from Docker Hub..."
docker pull $IMAGE_NAME

sleep 30

# Run the Docker image locally
echo "Running Docker image locally..."
docker run -d -p 8080:80 --name simple-web-app $IMAGE_NAME

# Print a message for user to check
echo "The web application is now running locally. Access it at http://localhost:8080"
