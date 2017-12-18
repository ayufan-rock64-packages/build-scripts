#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "usage: $0 package-name distribution"
  exit 1
fi

set -xeo pipefail

SOURCENAME="$1"
DISTRIBUTION="$2"

if [[ ! -d "$SOURCENAME" ]]; then
  echo "missing $SOURCENAME package"
  exit 1
fi

rm -f "${SOURCENAME}"_*.*

pushd "$SOURCENAME"
debuild -S -sa -kB11A62DE -d -I.git \
  --changes-option=-Ddistribution="${DISTRIBUTION}" \
  --release-by="Kamil Trzcinski <ayufan@ayufan.eu>"
popd

dput ppa:ayufan/rock64-ppa "${SOURCENAME}"_*.changes
