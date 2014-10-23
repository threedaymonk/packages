#!/bin/bash
set -e
source common.sh

name="slop"
version="3.1.9"
build_dir=$name
git_url='https://github.com/naelstrof/slop.git'

cd build
if [ ! -e $build_dir ]; then
  git clone $git_url
fi
cd $build_dir
git fetch --all
git reset --hard "v$version"

sudo apt-get install -y cmake libxext-dev

cmake ./
make

mkdir -p usr/bin
cp slop usr/bin/

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -d libxext6 \
  -a $DEB_BUILD_ARCH_CPU \
  usr/bin
