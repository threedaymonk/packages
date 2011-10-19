#!/bin/bash
set -e
DISTRIBUTIONS="current"
COMPONENTS="main"
ARCHITECTURES="amd64 i386"

mkdir -p repo/pool
cd repo

cp ../debs/*_all.deb pool/

for dist in $DISTRIBUTIONS; do
  for comp in $COMPONENTS; do
    for arch in $ARCHITECTURES; do
      path=dists/$dist/$comp/binary-$arch
      mkdir -p $path
      cat >$path/Release <<END
Archive: gds
Component: $comp
Origin: Government Digital Service, UK
Label: GDS Deployment Repository
Architecture: $arch
END
      cp ../debs/*_$arch.deb $path/ # TODO: Be cleverer about distributions
      dpkg-scanpackages $path /dev/null >  $path/Packages
      dpkg-scanpackages pool  /dev/null >> $path/Packages
      gzip -9c < $path/Packages > $path/Packages.gz
      rm $path/Packages
    done
  done
done
