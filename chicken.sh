#!/bin/bash
set -e
source common.sh

name="chicken"
release=4.9.0
patchlevel=1
version="${release}.${patchlevel}"
tar_url="http://code.call-cc.org/releases/$release/$name-$version.tar.gz"
build_dir="$name-$version"

cd build
if [ ! -e $build_dir ]; then
  curl --silent --location "$tar_url" | tar zxv
fi
cd $build_dir

make PLATFORM=linux PREFIX=/usr

checkinstall \
  --pkgname $name \
  --pkgversion $version \
  --pkglicense BSD \
  --requires libc6 \
  make PLATFORM=linux PREFIX=/usr install
