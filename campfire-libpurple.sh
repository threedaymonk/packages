#!/bin/bash
set -e
source common.sh

name="campfire-libpurple"
version="0.0.1"
build_dir=$name
git_url='git@github.com:jrfoell/campfire-libpurple.git'

cd build
if [ ! -e $build_dir ]; then
  git clone $git_url
fi
cd $build_dir
git fetch --all
git reset --hard origin/master

sudo apt-get install -y libpurple-dev

make

checkinstall \
  --pkgname="$name" \
  --pkgversion="$version" \
  --requires=libpurple0
