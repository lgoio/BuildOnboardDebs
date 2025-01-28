#!/bin/sh
WORKING_DIRECTORY="$(pwd)"
BUILD_SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
chmod +x "$BUILD_SCRIPT_PATH/build_debs.sh"
mkdir -p "$WORKING_DIRECTORY/debs/debian/bookworm"
# Build the Docker image
cd "$BUILD_SCRIPT_PATH"

if [ ! -f "qemu-armhf-static" ]; then
    if ! which qemu-armhf-static > /dev/null; then
        echo "qemu-armhf-static not found, please install it."
        echo "Run: sudo apt install qemu-user-static"
        exit 1
    fi
    cp "$(which qemu-armhf-static)" ./qemu-armhf-static
fi


if ! which docker > /dev/null; then
    echo "docker not found, please install it."
    echo "See: https://docs.docker.com/engine/install/"
    exit 1
fi


docker build --platform linux/armhf --network=host -f  Dockerfile_bookworm_armhf -t onboard_deb_build_bookwork_armhf .

# Run the container and mount the necessary volumes
docker run --rm \
  --network=host \
  -v"$BUILD_SCRIPT_PATH/build_debs.sh":/usr/local/bin/build_debs.sh \
  -v "$WORKING_DIRECTORY/debs/debian/bookworm/armhf":/debs \
  onboard_deb_build_bookwork_armhf $(id -u) $(id -g)
  
  	
