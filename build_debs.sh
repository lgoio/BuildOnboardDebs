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
WORKING_DIR="$(pwd)"
OUTPUT_DIR="$WORKING_DIR/debs/"

BUILD_PATH=$(mktemp -d /tmp/onboard_deb_build_XXXXX)

# Version
ONBOARD_VERSION="1.4.2.1"
ONBOARD_ARCHIVE="onboard_$ONBOARD_VERSION.orig.tar.gz"

# Install necessary dependencies
echo "Installing required dependencies..."
sudo apt-get update
sudo apt-get install -y dpkg-dev tar wget build-essential debhelper

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
cd "$BUILD_PATH/onboard-$ONBOARD_VERSION"

ARCHIVE_ONBOARD_VERSION="$(python3 setup.py --version | grep -v "dconf version" | grep -v "^[^0-9\.vV]+$" | head -n 1)"
if [ "$ONBOARD_VERSION" != "$ARCHIVE_ONBOARD_VERSION" ]; then
	echo "Rename $ONBOARD_ARCHIVE to onboard_$ARCHIVE_ONBOARD_VERSION.orig.tar.gz "
	mv "$BUILD_PATH/$ONBOARD_ARCHIVE" "$BUILD_PATH/onboard_$ARCHIVE_ONBOARD_VERSION.orig.tar.gz"
fi

# Install build dependencies
echo "Installing build dependencies..."
if ! sudo apt-get build-dep -y .; then
    echo "Failed to install build dependencies"
    exit 1
fi

# Build Debian package
echo "Building Debian package..."
if ! dpkg-buildpackage -us -uc; then
    echo "Error: Failed to build Debian package"
    rm -rf "$BUILD_PATH"
    exit 1
fi

# Return to build directory and copy `.deb` files to working directory
cd "$BUILD_PATH"
echo "Copying built packages to $OUTPUT_DIR..."
mkdir -p "$OUTPUT_DIR"
cp *.deb "$OUTPUT_DIR"

# Clean up temporary build directory
echo "Cleaning up temporary build directory..."
rm -rf "$BUILD_PATH"


cd "$OUTPUT_DIR"

# Generate metadata file Packages.gz for the repository
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

# Final message
echo "Debian packages successfully built and saved in $WORKING_DIR."
