#!/bin/bash
set -e
source common.sh

name="fsharp"
repo="git://github.com/fsharp/fsharp.git"
version=3.0.31

sudo apt-get install autoconf libtool pkg-config make git

cd build
if [ ! -e $name ]; then
  git clone $repo
fi

cd $name
git fetch --tags
git checkout $version
./autogen.sh --prefix /usr
make

rm -rf release
mkdir -p release/usr/bin release/usr/lib/mono
cp -R lib/release/* release/usr/lib/mono
for e in fsc fsi; do
  cat > release/usr/bin/$e <<END
#!/bin/sh
exec /usr/bin/mono \$MONO_OPTIONS /usr/lib/mono/4.0/$e.exe "\$@"
END
  chmod +x release/usr/bin/$e
done

cd ..

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C $name/release \
  -a $DEB_HOST_ARCH_CPU \
  -d mono-runtime \
  usr/bin usr/lib/mono
