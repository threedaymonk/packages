eval `dpkg-architecture`
deb_location=`pwd`/debs

mkdir -p debs build

fpm() {
  bundle exec fpm "$@"
  mv *.deb $deb_location
}

alias fpm="bundle exec fpm"

bundle
