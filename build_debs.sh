#!/bin/sh
WORKING_DIRECTORY="$(pwd)"
BUILD_SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
chmod +x "$BUILD_SCRIPT_PATH/docker/build_debs_in_docker.sh"
mkdir "$WORKING_DIRECTORY/build"
# Build the Docker image
cd "$BUILD_SCRIPT_PATH/docker"

docker build --network=host -t onboard_deb_build .

# Run the container and mount the necessary volumes
docker run --rm \
  --network=host \
  -v"$BUILD_SCRIPT_PATH/docker/build_debs_in_docker.sh":/usr/local/bin/build_debs_in_docker.sh \
  -v "$WORKING_DIRECTORY/build":/build \
  onboard_deb_build $(id -u) $(id -g)
  
  
