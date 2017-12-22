#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "usage: $0 package-directory distribution"
  exit 1
fi

set -eo pipefail

PACKAGE_DIR="$1"
DISTRIBUTION="$2"

echo "Entering $PACKAGE_DIR..."
cd "$PACKAGE_DIR"

SOURCE=$(dpkg-parsechangelog -S Source)
VERSION=$(dpkg-parsechangelog -S Version)
TAG_NAME="ayufan/rock64-ppa/${VERSION}/${DISTRIBUTION}"

echo "Building package '${SOURCE}' and '${VERSION}'..."

PACKAGE_FILE="../${SOURCE}_${VERSION}"

if ! git diff-files --quiet; then
  echo "Dirty repository. Commit changes!"
  exit 1
fi

echo "Cleaning previous packages..."
rm -f "${PACKAGE_FILE}.dsc" "${PACKAGE_FILE}_source.*"

echo "Creating tag '${TAG_NAME}'..."
git tag -a -m "${dpkg-parsechangelog}" "${TAG_NAME}"
trap 'git tag -d "${TAG_NAME}"' EXIT

echo "Building package for '${DISTRIBUTION}'..."
debuild -S -sa -kB11A62DE -d -I.git \
  --changes-option=-Ddistribution="${DISTRIBUTION}" \
  --release-by="Kamil Trzcinski <ayufan@ayufan.eu>"

echo "Uploading package '${PACKAGE_FILE}_source.changes'..."
dput ppa:ayufan/rock64-ppa "${PACKAGE_FILE}_source.changes"

echo "Uploading tag '${TAG_NAME}'..."
git push ayufan "${TAG_NAME}" || git push origin "${TAG_NAME}"
trap - EXIT

echo "Done."
