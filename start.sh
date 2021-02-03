#!/usr/bin/env bash

set -e
set -x

LINUX_HEADERS="linux-headers-$(uname -r)"
LINUX_IMAGE="linux-image-$(uname -r)"
sed -e "s@##LINUX_IMAGE###@${LINUX_IMAGE}@g" -e "s@###LINUX_HEADERS###@${LINUX_HEADERS}@g" Dockerfile.in > Dockerfile

if [ "$1" == "no-cache" ]; then
  docker build --no-cache -t local/debian10-ndpi .
else
  docker build -t local/debian10-ndpi .
fi

rm ./destdir -rf

docker run -i -t -v `pwd`:/build/ local/debian10-ndpi

cd destdir
tar cvfJ xt_ndpi.tar.xz ./*
tar tvf xt_ndpi.tar.xz
cd -

set +x
