#!/bin/sh
WORKING_DIRECTORY="$(pwd)"
BUILD_SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
chmod +x "$BUILD_SCRIPT_PATH/build_debs.sh"
mkdir -p "$WORKING_DIRECTORY/debs/debian/bookworm/x86_64"
# Build the Docker image
cd "$BUILD_SCRIPT_PATH"


if ! which docker > /dev/null; then
    echo "docker not found, please install it."
    echo "See: https://docs.docker.com/engine/install/"
    exit 1
fi


docker build --network=host -f  Dockerfile_bookworm -t onboard_deb_build_bookwork .

# Run the container and mount the necessary volumes
docker run --rm \
  --network=host \
  -v"$BUILD_SCRIPT_PATH/build_debs.sh":/usr/local/bin/build_debs.sh \
  -v "$WORKING_DIRECTORY/debs/debian/bookworm/x86_64":/debs \
  onboard_deb_build_bookwork $(id -u) $(id -g)
  
  	
