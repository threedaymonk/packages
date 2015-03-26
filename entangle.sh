#!/bin/bash
set -e
source common.sh

sudo apt-get install -y \
  intltool \
  libdbus-glib-1-dev \
  libgexiv2-dev \
  libgphoto2-2-dev \
  libgudev-1.0-dev \
  liblcms1-dev \
  libraw-dev \
  libgirepository1.0-dev \
  libpeas-dev

name="entangle"
version="0.5.1"
tar_url="http://entangle-photo.org/download/sources/entangle-$version.tar.gz"
build_dir="$name-$version"

cd build
if [ ! -e $build_dir ]; then
  curl --silent --location "$tar_url" | tar zxv
fi
cd $build_dir

./configure --prefix=/usr
make

checkinstall \
  --pkgname $name \
  --pkgversion $version \
  --pkglicense GPL3 \
  --requires gir1.2-gexiv2-0.4 \
  --requires gobject-introspection \
  --requires libdbus-glib-1-2 \
  --requires libgexiv2-1 \
  --requires libgphoto2-2 \
  --requires libgudev-1.0-0 \
  --requires liblcms1 \
  --requires libpeas-1.0-0 \
  --requires libraw5 \
  make install
