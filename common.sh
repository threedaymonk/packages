eval $(dpkg-architecture)
deb_location="$(pwd)/debs"

mkdir -p debs build

move_debs() {
  mv *.deb "$deb_location"
}

fpm() {
  bundle exec fpm "$@"
  move_debs
}

checkinstall() {
  sudo checkinstall --install=no --fstrans -y "$@"
  move_debs
}

alias fpm="bundle exec fpm"

bundle check || bundle install

if [ "$DEB_HOST_ARCH" = "amd64" ]; then
  bits=64
else
  bits=32
fi
