# Build Onboard Debian Packages

This repository provides a setup to build Onboard 1.4.2 .deb packages for Ubuntu 24.04 LTS using Docker.


## Directory Structure
- **`docker/`**: Contains the Docker setup, including the Dockerfile.
- **`build_debs.sh`**: A shell script to automate the build process.

## Requirements
- Docker: Version 20.10 or later is recommended.

## Instructions

### Step 1: Build the Docker Image and Debian Packages
Run the build_debs.sh script to build the Docker image and generate the .deb packages:
```bash
bash build_debs.sh
```
This script sets up the build environment inside a Docker container, mounts necessary volumes, and executes the build process.

### Step 2: Access the Output
Once the build is complete, all files including the generated .deb packages will be located in the $(pwd)/build directory.

