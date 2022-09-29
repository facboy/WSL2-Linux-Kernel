#!/bin/bash

set -eu

# debian dir needs to go or it makes the build failed - atm manually do this before
if [[ -e debian ]]; then
	>&2 echo "debian directory exists, please remove it"
	exit 1
fi

WSL2_DIR="/mnt/f/wsl/kernel/"

echo "Building kernel"
make KCONFIG_CONFIG=Microsoft/config-wsl deb-pkg

# work out kernel version
KERNEL_VER="$(ls -1tr ../linux-upstream_*.buildinfo | tail -n1 | gawk -- 'BEGIN { regex="^.*linux-upstream_([0-9.]+)-.*$" } $0 ~ regex { ver = gensub(regex, "\\1", 1); print ver }')"

echo "Copying bzImage to ${WSL2_DIR}"
cp "./arch/x86/boot/bzImage" "${WSL2_DIR}bzImage-${KERNEL_VER}-WSL2-mine"

ARCHIVE_DIR="${HOME}/kernel/${KERNEL_VER}/"
echo "Archiving build artifacts to ${ARCHIVE_DIR}"
mkdir "${ARCHIVE_DIR}"
cp ../linux-upstream_*${KERNEL_VER}* "${ARCHIVE_DIR}"
cp ../linux-*${KERNEL_VER}*.deb "${ARCHIVE_DIR}"
