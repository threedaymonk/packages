#!/bin/bash
set -e
source common.sh

name=thunderbird
version=38.0.1
os=linux64
lang=en-GB
download_link="https://download.mozilla.org/?product=$name-$version&os=$os&lang=$lang"

case "$DEB_BUILD_ARCH" in
  amd64)
    os=linux64
    ;;
  i386)
    os=linux
    ;;
  *)
    echo "Unsupported architecture $DEB_BUILD_ARCH"
    exit 1
esac


cd build
mkdir -p "$name-$version/opt"

pushd "$name-$version"

pushd opt
if [ ! -e $name ]; then
  curl --location --silent "$download_link" | tar jxv
fi
popd

mkdir -p usr/bin usr/share/applications
pushd usr/bin
ln -sf /opt/thunderbird/thunderbird thunderbird
popd

cat > usr/share/applications/thunderbird.desktop <<END
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Keywords=Email;E-mail;Newsgroup;Feed;RSS
Exec=thunderbird %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=x-scheme-handler/mailto;application/x-xpinstall;
StartupNotify=true
Actions=Compose;Contacts
END

popd

fpm \
  -s dir \
  -t deb \
  -n $name \
  -v 1:$version \
  -C $name-$version \
  -a "$DEB_BUILD_ARCH" \
  usr opt
