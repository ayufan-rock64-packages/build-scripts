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
VERSION=$(dpkg-parsechangelog -S Version | sed 's/.*://')
TAG_NAME="ayufan/rock64-ppa/${VERSION}/${DISTRIBUTION}"

echo "Building package '${SOURCE}' and '${VERSION}'..."

PACKAGE_FILE="../${SOURCE}_${VERSION}"

if [[ -d .git ]] && ! git diff-files --quiet; then
  echo "Dirty repository. Commit changes!"
  exit 1
fi

echo "Cleaning previous packages..."
rm -f "${PACKAGE_FILE}.dsc" "${PACKAGE_FILE}_source.*"

if [[ -d .git ]]; then
  echo "Creating tag '${TAG_NAME}'..."
  git tag -a -m "${dpkg-parsechangelog}" "${TAG_NAME}"
  trap 'git tag -d "${TAG_NAME}"' EXIT
else
  echo "Skipping tag creation, missing .git"
fi

echo "Building package for '${DISTRIBUTION}'..."
debuild -S -sa -kB11A62DE -d -I.git -I.vscode \
  --changes-option=-Ddistribution="${DISTRIBUTION}" \
  --release-by="Kamil Trzcinski <ayufan@ayufan.eu>"

echo "Uploading package '${PACKAGE_FILE}_source.changes'..."
dput ppa:ayufan/rock64-testing-ppa "${PACKAGE_FILE}_source.changes"

if [[ -d .git ]]; then
  echo "Uploading tag '${TAG_NAME}'..."
  git push ayufan "${TAG_NAME}" || git push origin "${TAG_NAME}"
  trap - EXIT
fi

echo "Done."
