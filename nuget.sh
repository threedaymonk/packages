#!/bin/bash
set -e
source common.sh

name="nuget"

# We can't just grep the version until Issue 3408 is resolved:
# https://nuget.codeplex.com/workitem/3408
if [ ! -e assembly-version.exe ]; then
  mcs assembly-version.cs
fi

mkdir -p build/nuget
cd build/nuget
if [ ! -e nuget.exe ]; then
  curl -L -o nuget.exe http://nuget.org/nuget.exe
fi

version=$(../../assembly-version.exe nuget.exe | grep -Eio 'Version=[0-9\.]+' | cut -d= -f2)

monodir=opt/mono
libdir=installdir/$monodir/lib/nuget
bindir=installdir/$monodir/bin

mkdir -p $libdir
cp nuget.exe $libdir
mkdir -p $bindir
cat >$bindir/nuget <<END
#!/bin/sh
exec /$monodir/bin/mono \$MONO_OPTIONS /$monodir/lib/nuget/nuget.exe "\$@"
END
chmod +x $bindir/nuget

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v $version \
  -C installdir \
  -d mono-opt \
  -a all \
  $monodir
