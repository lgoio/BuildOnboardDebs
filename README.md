# Build Onboard Deb packages with Docker
To create Deb packages on the host system, the `build_debs.sh` script is now available in the Onboard Git repository:  
[https://github.com/dr-ni/onboard/](https://github.com/dr-ni/onboard/)

This repository remains available for those who wish to cross-compile Onboard for various platforms using Docker and QEMU.

## Scripts Overview
- **`build_debs.sh`**: Builds `.deb` packages on the Host.
- **`docker_build_debs*.sh`**: Builds the packages inside a Docker container.

## Requirements
- **Docker**: Required for the Docker-based method.
- **Qemu**: Required for cross compiling.

## Build Instructions

### **1. Using Docker**
Run the following to build the packages in a container:
```bash
bash docker_build_ubuntu_24_04.sh
```
The `.deb` files will be saved in `$(pwd)/debs`.

### ** Building packages on the Host **

## Install Instructions

After building copy the debs directory to the target system.
Then, run the following command:
```bash
cd /path/to/debs/ubuntu/noble_numbat
sudo bash install_with_local_repo.sh
```
This script sets up a local APT repository, installs `onboard`, `onboard-data`, and `gnome-shell-extension-onboard`, and cleans up afterward.

