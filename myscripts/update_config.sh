#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f $0)")"
BASE_DIR="${SCRIPT_DIR}/.."

# on build it copies the existing `config-wsl` (which is actually a symlink) aside
# and then generates a new `config-wsl`. move the new config to the target of the
# symlink and then put the symlink back
MS_DIR="${BASE_DIR}/Microsoft"
OLD_SYMLINK="${MS_DIR}/config-wsl.old"

if [[ -f "${OLD_SYMLINK}" ]]; then
	CONFIG_FILE="${MS_DIR}/config-wsl"
	REAL_TARGET="$(readlink -f "${OLD_SYMLINK}")"

	mv "${CONFIG_FILE}" "${REAL_TARGET}"
	mv "${OLD_SYMLINK}" "${CONFIG_FILE}"
fi
