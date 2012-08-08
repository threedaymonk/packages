#!/bin/bash
set -e
source common.sh

name="phantomjs"
version=1.6.1
phantom="$name-$version-linux-$DEB_HOST_GNU_CPU-dynamic"

cd build
if [ ! -e $phantom ]; then
  curl -q "http://phantomjs.googlecode.com/files/$phantom.tar.bz2" | tar jxv
fi

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C $phantom \
  -a $DEB_HOST_ARCH_CPU \
  bin lib
