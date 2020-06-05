#!/usr/bin/env bash

# Apache License Version 2.0, January 2004
# https://github.com/aerokube/cm/blob/master/LICENSE

set -e +o pipefail

b="\033[0;36m"
g="\033[0;32m"
r="\033[0;31m"
e="\033[0;90m"
x="\033[0m"

say() {
  echo -e "$1"
}

say "${e}
 █████╗ ███████╗██████╗  ██████╗ ██╗  ██╗██╗   ██╗██████╗ ███████╗     ██████╗███╗   ███╗
██╔══██╗██╔════╝██╔══██╗██╔═══██╗██║ ██╔╝██║   ██║██╔══██╗██╔════╝    ██╔════╝████╗ ████║
███████║█████╗  ██████╔╝██║   ██║█████╔╝ ██║   ██║██████╔╝█████╗      ██║     ██╔████╔██║
██╔══██║██╔══╝  ██╔══██╗██║   ██║██╔═██╗ ██║   ██║██╔══██╗██╔══╝      ██║     ██║╚██╔╝██║
██║  ██║███████╗██║  ██║╚██████╔╝██║  ██╗╚██████╔╝██████╔╝███████╗    ╚██████╗██║ ╚═╝ ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝     ╚═════╝╚═╝     ╚═╝
${x}"

platform="$(uname -s)"
case "${platform}" in
    Linux*)     OS_TYPE=linux;;
    Darwin*)    OS_TYPE=darwin;;
    *)          say "${r}This script don't know how to deal with${x} ${platform} ${r}os type!${x}"; exit 1
esac

LATEST_BINARY_URL=`curl -s https://api.github.com/repos/aerokube/cm/releases/latest | grep "browser_download_url" | grep ${OS_TYPE} | cut -d : -f 2,3 | tr -d \"`

curl -L -o cm  $LATEST_BINARY_URL
chmod +x ./cm

VERSION=`./cm version`

say "
${g}SUCCESSFULLY DOWNLOADED!${x}

$VERSION

Now you can run ${b}Selenoid${x} with ${b}cm${x}:
    ${b}./cm selenoid start --vnc${x}

To get instant help just type:
    ${b}./cm --help${x}
"
