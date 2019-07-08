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

if git status &>/dev/null && ! git diff-files --quiet; then
  echo "Dirty repository. Commit changes!"
  exit 1
fi

cp debian/changelog debian/changelog.preserved
cleanup_changelog() {
  mv debian/changelog.preserved debian/changelog
}
trap cleanup_changelog EXIT

dch -U -D "$DISTRIBUTION" -l "$DISTRIBUTION" "Automated build for $DISTRIBUTION."

SOURCE=$(dpkg-parsechangelog -S Source)
VERSION=$(dpkg-parsechangelog -S Version | sed 's/.*://')
TAG_NAME="ayufan/rock64-ppa/${VERSION}"

echo "Building package '${SOURCE}' and '${VERSION}'..."

PACKAGE_FILE="../${SOURCE}_${VERSION}"

echo "Cleaning previous packages..."
rm -f "${PACKAGE_FILE}.dsc" "${PACKAGE_FILE}_source.*"

if [[ -d .git ]]; then
  echo "Creating tag '${TAG_NAME}'..."
  git tag -a -m "${dpkg-parsechangelog}" "${TAG_NAME}"
  trap 'git tag -d "${TAG_NAME}"; cleanup_changelog' EXIT
else
  echo "Skipping tag creation, missing .git"
fi

echo "Building package for '${DISTRIBUTION}'..."
debuild -S -sa -kC7EC42BB7050BC2009A1708136313C1D76A7CF2B -d -I.git -I.vscode \
  --release-by="Kamil Trzcinski <ayufan@ayufan.eu>"

echo "Uploading package '${PACKAGE_FILE}_source.changes'..."
dput ppa:ayufan/rock64-testing-ppa "${PACKAGE_FILE}_source.changes"

if [[ -d .git ]]; then
  echo "Uploading tag '${TAG_NAME}'..."
  git push ayufan "${TAG_NAME}" || git push origin "${TAG_NAME}" || true
  trap cleanup_changelog EXIT
fi

echo "Done."
