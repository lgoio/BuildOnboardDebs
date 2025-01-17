#!/bin/sh
# -e: Exit immediately if a command exits with a non-zero status
set -e
USER_ID=$1
GROUP_ID=$2

# Variables
BUILD_PATH="/build"
ARCH="amd64"
ONBOARD_VERSION="1.4.2"
ONBOARD_ARCHIVE="onboard_$ONBOARD_VERSION.orig.tar.gz"
ONBOARD_FILE_NAME="onboard_${ONBOARD_VERSION}_${ARCH}"
ONBOARD_SHA256_HASH="1292c5da5b5e6a62ebed9393823fc16b41a9d8f03859e4474417f7e02c020b57"

# Prepare build directory
mkdir -p "$BUILD_PATH"
cd "$BUILD_PATH"

# Remove older files if they exist
rm -rf "$BUILD_PATH"/* /tmp/*

# Download onboard tarball
if ! wget -q "https://github.com/dr-ni/onboard/archive/refs/tags/$ONBOARD_VERSION.tar.gz" -O "$ONBOARD_ARCHIVE"; then
    echo "Failed to download $ONBOARD_ARCHIVE"
    exit 1
fi

# Verify checksum
ONBOARD_CHECKSUM=$(sha256sum "$ONBOARD_ARCHIVE" | awk '{print $1}')
if [ "$ONBOARD_CHECKSUM" != "$ONBOARD_SHA256_HASH" ]; then
    echo "Checksum mismatch for $ONBOARD_ARCHIVE"
    rm "$ONBOARD_ARCHIVE"
    exit 1
fi

# Extract tarball
if ! tar xzf "$ONBOARD_ARCHIVE"; then
    echo "Failed to extract $ONBOARD_ARCHIVE"
    rm "$ONBOARD_ARCHIVE"
    exit 1
fi


# Workaround: Ignore changes in po/onboard.pot
echo 'extend-diff-ignore = "po/onboard.pot"' > "$BUILD_PATH/onboard-$ONBOARD_VERSION/debian/source/options"


# Navigate to extracted source directory
cd "$BUILD_PATH/onboard-$ONBOARD_VERSION"



# Install GSettings schema
if ! tools/install_gsettings_schema; then
    echo "Failed to install GSettings schema"
    exit 1
fi

# Build and install onboard
echo "Building and installing onboard..."
python3 setup.py clean
python3 setup.py build
python3 setup.py install

# Install build dependencies
echo "Installing build dependencies..."
if ! apt-get build-dep -y .; then
    echo "Failed to install build dependencies"
    exit 1
fi

# Build Debian package
echo "Building Debian package..."
if ! dpkg-buildpackage; then
    echo "Failed to build Debian package"
    cp  /tmp/*  "$BUILD_PATH"
    chown -R $USER_ID:$GROUP_ID "$BUILD_PATH"
    exit 1
fi
chown -R $USER_ID:$GROUP_ID "$BUILD_PATH"
echo "Build process completed successfully!"
