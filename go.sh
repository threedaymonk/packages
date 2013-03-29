#!/bin/bash
set -e
source common.sh

name="golang"
version="1.0.3"
tar_url="https://go.googlecode.com/files/go${version}.linux-${DEB_HOST_ARCH}.tar.gz"
build_dir="$name-$version"

cd build
if [ ! -e $build_dir ]; then
  curl -q "$tar_url" | tar zxv
  mkdir -p $build_dir/usr/local
  mv go $build_dir/usr/local
fi

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C $build_dir \
  -d build-essential \
  -a $DEB_HOST_ARCH_CPU \
  usr/local