# Build and Install Onboard Debian Packages

This repository provides tools to build and install Onboard `.deb` packages for Ubuntu 24.04 LTS. 
You can build the packages using **Docker** or directly on an **Ubuntu 24.04 system** and install them via a temporary local APT repository.

## Scripts Overview
- **`build_debs.sh`**: Builds `.deb` packages directly on Ubuntu.
- **`docker_build_debs.sh`**: Builds the packages inside a Docker container.
- **`install_with_local_repo.sh`**: Sets up a temporary local APT repository to install the built packages.

## Requirements
- **Docker**: Required for the Docker-based method.
- **Ubuntu 24.04**: Required for direct builds; dependencies are installed automatically by `build_debs.sh` and `install_with_local_repo.sh`.

## Build Instructions

### **1. Using Docker**
Run the following to build the packages in a container:
```bash
bash docker_build_debs.sh
```
The `.deb` files will be saved in `$(pwd)/debs`.

### **2. Using Ubuntu 24.04**
Run the following to build the packages directly:
```bash
bash build_debs.sh
```
The `.deb` files will be saved in the `debs/` directory.

## Install Instructions

After building the .deb packages, copy the debs directory and the install_with_local_repo.sh script to the target system.
Then, run the following command:
```bash
sudo bash install_with_local_repo.sh
```
This script sets up a local APT repository, installs `onboard`, `onboard-data`, and `gnome-shell-extension-onboard`, and cleans up afterward.

