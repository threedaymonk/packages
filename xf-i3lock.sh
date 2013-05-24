#!/bin/bash
set -e
source common.sh

name=xf-i3lock
version="1.0.0"

mkdir -p build/$name/installdir/usr/bin
cd build/$name

cat > installdir/usr/bin/xflock4 <<END
#!/bin/sh
xset dpms force off
i3lock --color=000000
END
chmod +x installdir/usr/bin/xflock4

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -d i3lock \
  -C installdir \
  -a all \
  usr
