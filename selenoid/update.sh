#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

#TODO: execute binary based on host architecture to support mac/win as well

echo downloading latest chrome/firefox/opera browser images

set -e +o pipefail

say() {
  echo -e "$1"
}

platform="$(uname -s)"
case "${platform}" in
    Linux*)     OS_TYPE=linux;;
    Darwin*)    OS_TYPE=darwin;;
    *)          say "This script don't know how to deal with ${platform} os type!"; exit 1
esac

LATEST_BINARY_URL=`curl -s https://api.github.com/repos/aerokube/cm/releases/latest | grep "browser_download_url" | grep ${OS_TYPE} | cut -d : -f 2,3 | tr -d \"`

curl -L -o ${BASEDIR}/bin/cm $LATEST_BINARY_URL
chmod +x ${BASEDIR}/bin/cm

VERSION=`${BASEDIR}/bin/cm version`

say "
SUCCESSFULLY DOWNLOADED!

$VERSION
"

${BASEDIR}/bin/cm selenoid update --vnc --config-dir "${BASEDIR}" $*

docker rm -f selenoid
