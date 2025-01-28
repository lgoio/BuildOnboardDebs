#!/bin/sh
WORKING_DIRECTORY="$(pwd)"
BUILD_SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
chmod +x "$BUILD_SCRIPT_PATH/build_debs.sh"
mkdir -p "$WORKING_DIRECTORY/debs/debian/bookworm/arm64v8"
# Build the Docker image
cd "$BUILD_SCRIPT_PATH"

if [ ! -f "qemu-arm64-static" ]; then
    if ! which qemu-arm64-static > /dev/null; then
        echo "qemu-arm64-static not found, please install it."
        echo "Run: sudo apt install qemu-user-static"
        exit 1
    fi
    cp "$(which qemu-arm64-static)" ./qemu-arm64-static
fi


if ! which docker > /dev/null; then
    echo "docker not found, please install it."
    echo "See: https://docs.docker.com/engine/install/"
    exit 1
fi


docker build --platform linux/arm64 --network=host -f  Dockerfile_bookworm_arm64v8 -t onboard_deb_build_bookwork_arm64v8 .

# Run the container and mount the necessary volumes
docker run --rm \
  --network=host \
  -v"$BUILD_SCRIPT_PATH/build_debs.sh":/usr/local/bin/build_debs.sh \
  -v "$WORKING_DIRECTORY/debs/debian/bookworm/arm64v8":/debs \
  onboard_deb_build_bookwork_arm64v8 $(id -u) $(id -g)
  
  	
