#!/bin/sh

# Description:
# This script automates the process of building Debian packages for the Onboard software.
# It:
# 1. Creates a temporary build directory.
# 2. Downloads the specified version of the Onboard source tarball.
# 3. Verifies and extracts the tarball.
# 4. Installs necessary dependencies for the build process.
# 5. Builds the Debian package using dpkg-buildpackage.
# 6. Copies the resulting `.deb` files to a directory in the current working directory.
# 7. Cleans up the temporary build directory.
# 8. Generates a metadata file (Packages.gz) for setting up a local APT repository.

# Variables
USER_ID=$1
GROUP_ID=$2

OUTPUT_DIR="$(pwd)/debs"

BUILD_PATH=$(mktemp -d /tmp/onboard_deb_build_XXXXX)

# Version
ONBOARD_VERSION="v1.4.2-1"
ONBOARD_ARCHIVE="onboard_$ONBOARD_VERSION.orig.tar.gz"

# Install necessary dependencies
echo "Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y tar wget

echo "Create temporary build directory: $BUILD_PATH"
# Prepare build directory
mkdir -p "$BUILD_PATH"
cd "$BUILD_PATH"


# Download onboard tarball
echo "Downloading Onboard source tarball..."
if ! wget -q "https://github.com/dr-ni/onboard/archive/refs/tags/$ONBOARD_VERSION.tar.gz" -O "$ONBOARD_ARCHIVE"; then
    echo "Error: Failed to download $ONBOARD_ARCHIVE"
    rm -rf "$BUILD_PATH"
    exit 1
fi

# Extract tarball
echo "Extracting source tarball..."
if ! tar xzf "$ONBOARD_ARCHIVE"; then
    echo "Error: Failed to extract $ONBOARD_ARCHIVE"
    rm -rf "$BUILD_PATH"
    exit 1
fi

# Navigate to extracted source directory
cd "$BUILD_PATH/onboard-"*

chmod +x build_debs.sh
./build_debs.sh

# Return to build directory and copy `.deb` files to working directory
echo "Copying built packages to $OUTPUT_DIR..."
mkdir -p "$OUTPUT_DIR"
rm -Rf "$OUTPUT_DIR/"*

mv ./build/debs/*.deb "$OUTPUT_DIR"
mv ./build/debs/Packages.gz "$OUTPUT_DIR"
chmod +x install_debs_with_local_repo.sh
mv ./install_debs_with_local_repo.sh "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

chown -R $USER_ID:$GROUP_ID "$OUTPUT_DIR"

# Clean up temporary build directory
echo "Cleaning up temporary build directory..."
rm -rf "$BUILD_PATH"

# Final message
echo "Debian packages successfully built and saved in $OUTPUT_DIR."
cd "$OUTPUT_DIR"
