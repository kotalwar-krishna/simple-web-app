# Simple Web Application CI/CD with Docker and GitHub Actions

This project showcases a straightforward web application integrated with a CI/CD pipeline utilizing **Docker**, **GitHub Actions**, and **Ansible**. The application is containerized with Docker, and the Docker image is pushed to Docker Hub. This image can then be pulled from Docker Hub and executed locally, facilitating easy deployment and testing.

## Table of Contents
- [Project Overview](#project-overview)
- [Setup and Run Locally](#setup-and-run-locally)
- [CI/CD Pipeline Overview](#ci-cd-pipeline-overview)
- [Dockerfile Details](#dockerfile-details)
- [Ansible Playbook Details](#ansible-playbook-details)
- [Challenges and Solutions](#challenges-and-solutions)

## Project Overview
This project is a basic web application using HTML and JavaScript. It displays a "Hello, World!" message and is containerized using Docker. Configuration management and deployment are automated with Ansible, and a CI/CD pipeline is set up using GitHub Actions.

## Flow Diagram

Below is the flow diagram illustrating the CI/CD pipeline:

![Alt text](/flowchart.png)

## Setup and Run Locally
To set up and run the application locally, follow these steps: 

**Prerequisites:**
**Docker:** Ensure Docker is installed locally on your machine. You can download and install Docker from the official Docker website.

1. **Clone the Repository, Build and Run**:
   ```bash
   git clone https://github.com/your-username/simple-web-app.git
   cd simple-web-app
   docker build -t simple-web-app .
   docker run -d -p 8080:80 simple-web-app
   ```
2. **Pull the image from dockerhub and Run**
   ```bash
   docker pull krishnakotalwar/simple-web-app:latest
   docker run -d -p 8080:80 krishnakotalwar/simple-web-app:latest
   ```
3. **By Pushing changes to repo**
Go t0 (`/ansible/hosts.ini`) and change webserver configuration according to your local machine. 
push the changes.
example : put <Host adreess> ansible_connection=ssh ansible_user=<user_name> ansible_password=<password> ansible_port=<port>

**Access the Application:** Open your browser and go to (`http://localhost:8080`) to see the "Hello, World !!" message.

## CI/CD Pipeline Overview
The CI/CD pipeline is set up using GitHub Actions to automate the build, test, and pushing image to dockerhub process:

**Build:** Docker image is built from the Dockerfile.
**Test:** Any unit tests are run (if applicable).
**Push image to dockerhub:** Docker container is started, and Ansible is used for configuration and deployment.
The workflow file (`.github/workflows/ci-cd.yml`) defines the steps for this pipeline.

**Steps involved** 
1. Checkout the code
2. installation of Docker
3. Installation of ansible
4. build and push the image to docker hub
5. Run ansible playbook to pull and deploy image locally

## Dockerfile Details

**Base Image:** (`nginx:alpine`) provides a minimal NGINX server on Alpine Linux.
File Copy: (`index.html`) is placed into the directory where NGINX looks for static files.
Port Exposure: Port 80 is indicated for HTTP traffic.
Command: Runs NGINX in the foreground to ensure proper operation within the container.
This Dockerfile sets up a basic web server using NGINX to serve a static (`index.html`) file.

## Ansible Playbook Details

This playbook sets up a Docker environment by:

Resolving any package conflicts and cleaning up the package system.
Installing Docker.
Building a Docker image from a Dockerfile.
Managing Docker containers by stopping and removing any existing ones, and then starting a new container based on the newly built image.

## Challenges and Solutions

1. Using Ansible using windows PC / Run ansible playbook Using windows PC. → Used WSL
2. While running github action flow faced difficulties while installation of docker → Downloaded Docker from script
3. While running workflow got to know previous image is vanishing from docker → updated github action workflow to tag previous image with run no.
4. Connecting Local machine from Ansible playbook Running on github using WSL IP → Used ngrok
5. Got authentication error while connecting local host from ansible playbook → used ANSIBLE_HOST_KEY_CHECKING=False
6. Not able to connect using private key to local machine → used ansible_sudo_ pass for sudo.


