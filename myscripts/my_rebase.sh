#!/bin/bash

uname | grep -qe "Linux"
if [[ $? -ne 0 ]]; then
	>&2 echo "Must be run on Linux"
	exit 1
fi

set -e

MINE_BRANCH="mine-6.1"
MINE_BASE="mine-6.1-base"
UPSTREAM_BRANCH="linux-6.1.y"
UPSTREAM="linux-stable/${UPSTREAM_BRANCH}"
MY_UPSTREAM_BRANCH="linux-mine-wsl-6.1.y"

if [[ "$(git branch --show-current)" != "${MINE_BRANCH}" ]]; then
	>&2 echo "Not on ${MINE_BRANCH} branch"
	exit 1
fi

git fetch linux-stable --prune

# check out my upstream branch and merge upstream
git co "${MY_UPSTREAM_BRANCH}"
git merge "${UPSTREAM}"

git co "${MINE_BRANCH}"

merge_base="$(git merge-base "${MINE_BRANCH}" "${MY_UPSTREAM_BRANCH}")"
upstream_commit="$(git rev-parse "${MY_UPSTREAM_BRANCH}")"

if [[ "${merge_base}" != "${upstream_commit}" ]]; then
	git rebase --onto "${MY_UPSTREAM_BRANCH}" "${MINE_BASE}"
fi

git branch -cf "${MY_UPSTREAM_BRANCH}" "${MINE_BASE}"
git branch --no-track -f "${UPSTREAM_BRANCH}" "${UPSTREAM}"
# git push origin "${MINE_BRANCH}" # needs --force
git push origin "${MY_UPSTREAM_BRANCH}"
git push origin "${UPSTREAM_BRANCH}"
