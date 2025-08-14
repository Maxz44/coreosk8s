#!/bin/bash
set -e

type podman > /dev/null

test -f fedora-coreos-*-live-iso.x86_64.iso || podman run -it --rm -v $PWD:/app:z -w /app quay.io/coreos/coreos-installer:release download --format=iso
