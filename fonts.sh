#!/bin/bash
set -e
source common.sh

name=$1
source=$2
fontpath="usr/share/fonts/truetype/$name"
version="1.0.0"
builddir="build/$name/installdir/$fontpath"

if [ "$name" = "" ] || [ "$source" = "" ]; then
  echo "Usage: $0 package-name path-with-fonts"
  exit 1
fi

mkdir -p "$builddir"
for f in "$source"/**/*.{ttf,ttc,otf}; do
  if [ -f "$f" ]; then
    cp -v "$f" "$builddir"/
  fi
done

cd "build/$name"

cat > update.sh <<END
#!/bin/sh
fc-cache -s /$fontpath
END
chmod +x update.sh

fpm \
  -s dir \
  -t deb \
  -n "$name" \
  -v $version \
  -C installdir \
  -a all \
  --after-install update.sh \
  --after-remove update.sh \
  "$fontpath"
