#!/bin/bash
set -e
source common.sh

name=haskell-platform
version=2014.2.0.0
package="${name}-${version}-unknown-linux-x86_64"
tarball="${package}.tar.gz"
tarball_url="https://www.haskell.org/platform/download/${version}/${tarball}"
prefix=usr/local

make_symlinks() {
  local source=$1
  local dest=$2

  mkdir -p "$prefix/$dest"
  pushd "$prefix" >/dev/null
  for f in haskell/ghc*/"$source"/*; do
    ln -sf "/$prefix/$f" "$dest"
  done
  popd >/dev/null
}

cd build

[ -e $tarball ] || curl --location --output $tarball $tarball_url

mkdir -p $package
cd $package

[ -e usr ] || tar zxf ../$tarball

make_symlinks bin bin
make_symlinks share/man/man1 share/man/man1
make_symlinks share/doc/ghc share/doc

cat > update.sh <<END
#!/bin/sh
set -e
ghcRoot="\$(dirname \$(dirname \$(readlink /${prefix}/bin/ghc)))"

for conf in \$(ls "\$ghcRoot"/etc/registrations); do
  "\$ghcRoot"/bin/ghc-pkg register --verbose=0 --force \\
    "\$ghcRoot/etc/registrations/\$conf" 2>/dev/null || true
done
END
chmod +x update.sh

fpm \
  -s dir \
  -t deb \
  --name $name \
  --version $version \
  -C . \
  --architecture amd64 \
  --after-install update.sh \
  --depends libgmp-dev \
  --depends lib32z1-dev \
  usr
