#!/bin/bash
set -eux -o pipefail

# Fetch the GPG public key for the deadsnakes PPA
gpg --keyserver keyserver.ubuntu.com --recv-keys F23C5A6CF475977595C89F51BA6932366A755776
gpg --export F23C5A6CF475977595C89F51BA6932366A755776 > /usr/share/keyrings/ppa-deadsnakes.gpg

# The focal version is selected because it was release slightly before bullseye, update to jammy for bookworm
cat >>/etc/apt/sources.list.d/ppa-deadsnakes.list <<EOF
deb [signed-by=/usr/share/keyrings/ppa-deadsnakes.gpg] http://ppa.launchpad.net/deadsnakes/ppa/ubuntu focal main
EOF

# Run update here so we know if this PPA works
apt-get -y update

# venv versions have the ensurepip library
apt-get -y install python3.11-venv
# setup pip using python 3.11
python3.11 -m ensurepip --default-pip
# make this the default python
ln -sf /usr/bin/python3.11 /usr/bin/python3