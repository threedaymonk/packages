#!/bin/bash
set -e
source common.sh

name="chicken"
version="4.8.0.3"
release="4.8.0"
tar_url="http://code.call-cc.org/releases/$release/$name-$version.tar.gz"
build_dir="$name-$version"

cd build
if [ ! -e $build_dir ]; then
  curl --silent --location "$tar_url" | tar zxv
fi
cd $build_dir

make PLATFORM=linux PREFIX=/usr

sudo checkinstall \
  --pkgname $name \
  --pkgversion $version \
  --pkglicense BSD \
  --requires libc6 \
  --install=no \
  -y \
  make PLATFORM=linux PREFIX=/usr install

mv *.deb ../../debs/
