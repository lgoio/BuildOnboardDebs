# Use Ubuntu 24.04 (Noble Numbat) as the base image
FROM ubuntu:24.04

# Install essential tools and compilers for mpa104 and onboard
RUN apt-get update && apt-get install -y \
    wget  build-essential python3-packaging python3-dev \
    dh-python python3-distutils-extra devscripts pkg-config \
    libgtk-3-dev libxtst-dev libxkbfile-dev libdconf-dev libcanberra-dev \
    libhunspell-dev libudev-dev \
    python3-all-dev python3-cairo debhelper

WORKDIR /

ENTRYPOINT ["/usr/local/bin/build_debs_in_docker.sh"]

