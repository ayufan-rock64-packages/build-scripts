#!/bin/bash

set -xe

if [[ $# -ne 2 ]]; then
    echo "usage: $0 project-name branch-name"
    exit 1
fi

PROJECT_NAME="$1"
BRANCH_NAME="$2"
shift 2

if [[ ! -d "$PROJECT_NAME" ]]; then
    git clone "https://github.com/ayufan-rock64/$PROJECT_NAME" --branch="$BRANCH_NAME"
fi

pushd "$PROJECT_NAME"
rev=$(git rev-parse HEAD)
trap "git reset --hard $rev" ERR

git pull "https://github.com/rockchip-linux/$PROJECT_NAME" "$BRANCH_NAME"
new_rev=$(git rev-parse HEAD)

if [[ "$rev" == "$new_rev" ]] && [[ -z "$FORCE" ]]; then
    echo "Everything is up-to date"
    exit 0
fi

dch -M -U -D xenial -l ayufan Automated release
git commit -am "Bump version"
git push

debuild -S -sa -kB11A62DE
dput ppa:ayufan/rock64-ppa ../$PROJECT_NAME*.changes
