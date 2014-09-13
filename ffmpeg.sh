#!/bin/bash
set -e
source common.sh

name="ffmpeg"
version=2.3.3
basename="${name}-${version}-${DEB_BUILD_ARCH_BITS}bit-static"
url="http://johnvansickle.com/ffmpeg/releases/${basename}.tar.bz2"

cd build
if [ ! -e $basename ]; then
  curl -L -q "$url" | tar jxv
fi

cd $basename
mkdir -p usr/bin usr/share/ffmpeg
cp ffmpeg ffmpeg-10bit ffprobe  usr/bin/
cp -R presets usr/share/ffmpeg/
cd ..

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C $basename \
  -a $DEB_BUILD_ARCH_CPU \
  usr
