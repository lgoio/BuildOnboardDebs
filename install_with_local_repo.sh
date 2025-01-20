#!/bin/sh

# Description:
# This script sets up a temporary local APT repository for the Onboard packages
# located in the "onboard" subdirectory of the script's location.
# It configures the local repository, updates the package index, and installs the
# necessary Onboard packages (onboard, onboard-data, gnome-shell-extension-onboard).
# After installation, the temporary repository configuration is removed.

# Note: This script must be executed as root.

# Get the absolute path of the script's directory
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Configure a local APT repository
echo "deb [trusted=yes] file:$SCRIPT_PATH/onboard ./" > /etc/apt/sources.list.d/onboardlocalrepo.list

# Update package index for the temporary local repository
apt-get update -o Dir::Etc::sourcelist="/etc/apt/sources.list.d/onboardlocalrepo.list"

# Install the Onboard packages
apt-get -y install onboard onboard-data gnome-shell-extension-onboard

# Remove the temporary local repository configuration
rm /etc/apt/sources.list.d/onboardlocalrepo.list
