#!/bin/bash
set -e
source common.sh

name="golang"
version="1.2.1"
tar_url="https://go.googlecode.com/files/go${version}.linux-${DEB_HOST_ARCH}.tar.gz"
build_dir="$name-$version"
epoch=2

cd build
if [ ! -e $build_dir ]; then
  curl -q "$tar_url" | tar zxv
  mkdir -p $build_dir/usr/local
  mv go $build_dir/usr/local/
fi
mkdir -p $build_dir/usr/local/bin
for f in $build_dir/usr/local/bin/*; do
  ln -sf /usr/local/go/bin/$(basename $f) $build_dir/usr/local/bin/
done

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $epoch:$version \
  -C $build_dir \
  -d build-essential \
  -a $DEB_HOST_ARCH_CPU \
  usr/local
