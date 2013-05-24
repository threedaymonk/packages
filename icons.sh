#!/bin/bash
set -e
source common.sh

name=pb-lubuntu-icon-theme
version="1.0.2"

mkdir -p build/$name/installdir/usr/share/icons
cp -R pb-lubuntu-tweak build/$name/installdir/usr/share/icons/
cd build/$name

fpm \
  -s dir \
  -t deb \
  -n $name \
  -d lubuntu-elementary-icon-theme \
  -v $version \
  -C installdir \
  -a all \
  usr
