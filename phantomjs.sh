#!/bin/bash
set -e
source common.sh

name="phantomjs"
version=1.7.0
phantom="$name-$version-linux-$DEB_HOST_GNU_CPU"

cd build
if [ ! -e $phantom ]; then
  curl -q "http://phantomjs.googlecode.com/files/$phantom.tar.bz2" | tar jxv
fi

cd $phantom
for f in bin lib; do
  if [ -e $f ]; then
    mkdir -p usr
    mv $f usr/
  fi
done
cd ..

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C $phantom \
  -a $DEB_HOST_ARCH_CPU \
  usr/bin
