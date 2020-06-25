#!/bin/bash

BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd ${BASEDIR}

HOST_NAME=$1

if [ $# -lt 1 ]; then
    printf 'Usage: %s HOST_NAME\n' "$(basename "$0")" >&2
    exit -1
fi

if [ $HOST_NAME == "localhost" ] || [ $HOST_NAME == "127.0.0.1" ]; then
    printf "Use fully qualified domain name or your server ip address to setup!"
    exit -1
fi

echo "
███████╗███████╗██████╗ ██████╗ ██╗   ██╗███╗   ██╗███╗   ██╗███████╗██████╗
╚══███╔╝██╔════╝██╔══██╗██╔══██╗██║   ██║████╗  ██║████╗  ██║██╔════╝██╔══██╗
  ███╔╝ █████╗  ██████╔╝██████╔╝██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██████╔╝
 ███╔╝  ██╔══╝  ██╔══██╗██╔══██╗██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██╔══██╗
███████╗███████╗██████╔╝██║  ██║╚██████╔╝██║ ╚████║██║ ╚████║███████╗██║  ██║
╚══════╝╚══════╝╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝

        ███████╗████████╗ █████╗ ██████╗ ████████╗███████╗██████╗
        ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝██╔════╝██╔══██╗
        ███████╗   ██║   ███████║██████╔╝   ██║   █████╗  ██████╔╝
        ╚════██║   ██║   ██╔══██║██╔══██╗   ██║   ██╔══╝  ██╔══██╗
        ███████║   ██║   ██║  ██║██║  ██║   ██║   ███████╗██║  ██║
        ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝

"

echo generating .env...
sed 's/demo.qaprosoft.com/'$1'/g' .env.original > .env
echo generating ./nginx/conf.d/default.conf...
sed 's/demo.qaprosoft.com/'$1'/g' ./nginx/conf.d/default.conf.original > ./nginx/conf.d/default.conf

echo WARNING! Increase vm.max_map_count=262144 appending it to /etc/sysctl.conf on Linux Ubuntu
echo your current value is `sysctl vm.max_map_count`

./selenoid/update.sh
echo Setup finished successfully using $HOST_NAME hostname.
