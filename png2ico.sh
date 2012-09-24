#!/bin/bash
set -e
source common.sh

name="png2ico"
version=2002-12-08
tar_url="http://www.winterdrache.de/freeware/png2ico/data/$name-src-$version.tar.gz"

cd build
if [ ! -e $name ]; then
  curl -q "$tar_url" | tar zxv
fi
cd $name

make

mkdir -p release/usr/{bin,share/man/man1}
cp png2ico release/usr/bin/
gzip < doc/png2ico.1 > release/usr/share/man/man1/png2ico.1.gz

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -d libpng12-0 \
  -d zlib1g \
  -C release \
  -a $DEB_HOST_ARCH_CPU \
  usr/bin usr/share
