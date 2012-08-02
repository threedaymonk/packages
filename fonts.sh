#!/bin/bash
set -e

name=$1
source=$2
location=`pwd`
fontpath="usr/share/fonts/truetype/$name"
version="1.0.0"

if [ "$name" = "" ] || [ "$source" = "" ]; then
  echo "Usage: $0 package-name path-with-fonts"
  exit 1
fi

mkdir -p debs
mkdir -p build/$name/installdir/$fontpath
cp -R $source/* build/$name/installdir/$fontpath/

cd build/$name

cat > update.sh <<END
#!/bin/sh
fc-cache -s /$fontpath
END
chmod +x update.sh

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C installdir \
  -a all \
  --after-install update.sh \
  --after-remove update.sh \
  $fontpath

mv *.deb $location/debs
