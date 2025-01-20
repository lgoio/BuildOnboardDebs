#!/bin/sh
WORKING_DIRECTORY="$(pwd)"
BUILD_SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
chmod +x "$BUILD_SCRIPT_PATH/build_debs.sh"
mkdir "$WORKING_DIRECTORY/debs"
# Build the Docker image
cd "$BUILD_SCRIPT_PATH"

docker build --network=host -t onboard_deb_build .

# Run the container and mount the necessary volumes
docker run --rm \
  --network=host \
  -v"$BUILD_SCRIPT_PATH/build_debs.sh":/usr/local/bin/build_debs.sh \
  -v "$WORKING_DIRECTORY/debs":/debs \
  onboard_deb_build $(id -u) $(id -g)
  
  	
