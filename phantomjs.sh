#!/bin/bash
set -e

eval `dpkg-architecture`

name="phantomjs"
version=1.6.1
location=`pwd`
phantom="$name-$version-linux-$DEB_HOST_GNU_CPU-dynamic"

mkdir -p debs
mkdir -p build

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

mv *.deb $location/debs
