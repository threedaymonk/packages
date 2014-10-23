#!/bin/bash
set -e
source common.sh

name="maim"
version="2.3.30"
build_dir=$name
git_url='https://github.com/naelstrof/maim.git'

cd build
if [ ! -e $build_dir ]; then
  git clone $git_url
fi
cd $build_dir
git fetch --all
git reset --hard "v$version"

sudo apt-get install -y cmake libimlib2-dev libxrandr-dev libxfixes-dev

cmake ./
make

mkdir -p usr/bin
cp maim usr/bin/

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -d libxrandr2 \
  -d libimlib2 \
  -d libxfixes3 \
  -d slop \
  -a $DEB_BUILD_ARCH_CPU \
  usr/bin
