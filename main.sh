#!/bin/bash
set -ev

type \
    envsubst \
    podman \
        > /dev/null

# Download iso file
test -f fedora-coreos-*-live-iso.x86_64.iso || \
podman run -it --rm -v $PWD:/app:z -w /app \
    quay.io/coreos/coreos-installer:release \
    download --format=iso

# Populate butane template file
set -a; source .env; set +a
envsubst < main.bu.template > main.bu

# Butane to ignition compilation
podman run --interactive --rm quay.io/coreos/butane:release \
       --pretty --strict < main.bu > main.ign

# Write an iso file
podman run -it --rm -v $PWD:/app:z -w /app \
    quay.io/coreos/coreos-installer:release \
    iso ignition embed \
    --ignition-file main.ign \
    --output coreos.iso \
    --dest-device /dev/sda \
    fedora-coreos-*-live-iso.x86_64.iso
