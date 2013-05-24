eval `dpkg-architecture`
deb_location=`pwd`/debs

mkdir -p debs build

fpm() {
  bundle exec fpm "$@"
  mv *.deb $deb_location
}

alias fpm="bundle exec fpm"

bundle

if [ "$DEB_HOST_ARCH" = "amd64" ]; then
  bits=64
else
  bits=32
fi
