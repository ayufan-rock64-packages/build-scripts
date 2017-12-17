#!/bin/bash

set -xe

if [[ $# -lt 3 || $# -gt 5 ]]; then
    echo "usage: $0 group-name project-name branch-name [package-name distro-xenial-zesty]"
    exit 1
fi

GROUP_NAME="$1"
PROJECT_NAME="$2"
BRANCH_NAME="$3"
PACKAGE_NAME="${4-$2}"
DISTRO="${5-xenial}"

if [[ ! -d "$PROJECT_NAME" ]]; then
    git clone "https://github.com/ayufan-rock64/$PROJECT_NAME" --branch="$BRANCH_NAME"
fi

pushd "$PROJECT_NAME"
git checkout "$BRANCH_NAME"
rev=$(git rev-parse HEAD)
trap "git reset --hard $rev" ERR

git remote add upstream "https://github.com/$GROUP_NAME/$PROJECT_NAME" || true

git pull upstream "$BRANCH_NAME" || (
    echo Press ENTER to continue
    read PROMPT
    git commit
)
new_rev=$(git rev-parse HEAD)

if [[ "$rev" == "$new_rev" ]] && [[ -z "$FORCE" ]]; then
    echo "Everything is up-to date"
    exit 0
fi

dch -M -U -D "$DISTRO" -l ayufan Automated release
git commit -am "Bump version"
git push

rm -f ../${PACKAGE_NAME}_*
debuild -S -sa -kB11A62DE
dput ppa:ayufan/rock64-ppa ../${PACKAGE_NAME}_*.changes
