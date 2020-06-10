#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

set -e +o pipefail

b="\033[0;36m"
g="\033[0;32m"
r="\033[0;31m"
e="\033[0;90m"
x="\033[0m"

say() {
  echo -e "$1"
}

platform="$(uname -s)"
case "${platform}" in
    Linux*)     OS_TYPE=linux;;
    Darwin*)    OS_TYPE=darwin;;
    *)          say "${r}This script don't know how to deal with${x} ${platform} ${r}os type!${x}"; exit 1
esac

LATEST_BINARY_URL=`curl -s https://api.github.com/repos/aerokube/cm/releases/latest | grep "browser_download_url" | grep ${OS_TYPE} | cut -d : -f 2,3 | tr -d \"`

curl -L -o ${BASEDIR}/bin/cm  $LATEST_BINARY_URL
chmod +x ${BASEDIR}/bin/cm

VERSION=`${BASEDIR}/bin/cm version`

say "
${g}SUCCESSFULLY DOWNLOADED!${x}

$VERSION
"
