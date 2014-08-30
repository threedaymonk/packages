#!/bin/bash
# Build a repository from the debs in debs/.

set -e
DISTRIBUTIONS="current"
COMPONENTS="main"
ARCHITECTURES="amd64 i386"
ORIGIN="Paul Battley"
LABEL="Personal packages"
DESCRIPTION="Things for my personal use"
ARCHIVE="pdb"
SIGNER="Paul Battley <pbattley@gmail.com>"

rm -rf repo
mkdir -p repo/pool
cp debs/*.deb repo/pool/

cd repo

for dist in $DISTRIBUTIONS; do
  for comp in $COMPONENTS; do
    for arch in $ARCHITECTURES; do
      path=dists/$dist/$comp/binary-$arch
      mkdir -p $path
      cat >$path/Release <<END
Archive: $ARCHIVE
Component: $comp
Origin: $ORIGIN
Label: $LABEL
Architecture: $arch
END
      dpkg-scanpackages -a $arch pool /dev/null > $path/Packages
      gzip -9c < $path/Packages > $path/Packages.gz
    done
  done
  cat > Release <<END
Origin: $ORIGIN
Label: $LABEL
Suite: $dist
Codename: $dist
Architectures: $ARCHITECTURES
Components: $COMPONENTS
Description: $DESCRIPTION
END
  apt-ftparchive release dists/$dist >> Release
  gpg -abs \
    --local-user "$SIGNER" \
    --output dists/$dist/Release.gpg \
    Release
  mv Release dists/$dist/
done
