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
3. **Use bash script in repo**
   clone the repo first and then run bash script. it will ask you what massage you want to print
   ```bash
   git clone https://github.com/your-username/simple-web-app.git
   cd simple-web-app
   ./run_app.sh
   ```

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
4. Run ansible playbook and test
5. push the image to docker hub

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

1. Ansible on Windows
**Challenge:** Running Ansible directly on Windows is not supported natively.
**Solution:** Used Windows Subsystem for Linux (WSL) to provide a Linux environment on the Windows machine. This allows Ansible to run within a Linux shell, and Docker Desktop was integrated with WSL to allow Docker commands to work seamlessly.
2. GitHub Actions and Ansible Playbook Error
**Challenge:** During the execution of the Ansible playbook in GitHub Actions, an error occurred when trying to install Docker:
```kotlin
Error, pkgProblemResolver::Resolve generated breaks, this may be caused by held packages.
```
**Solution:** Used Docker official installation script
```yml
      - name: Install Docker
        run: |
          curl -fsSL https://get.docker.com -o get-docker.sh
          sudo sh get-docker.sh
```
3. The error in your Ansible playbook
**challenge:** (pkgProblemResolver::Resolve generated breaks, this may be caused by held packages) indicates a conflict between containerd.io and containerd. To resolve this issue, you need to handle the package conflict and potential held packages during your playbook execution.

**Solution:**
Remove Conflicting containerd Package: Ensure that the conflicting containerd package is removed before installing docker.io or containerd.io.
Unhold Held Packages: If there are any held packages, you can unhold them to allow proper installation.

