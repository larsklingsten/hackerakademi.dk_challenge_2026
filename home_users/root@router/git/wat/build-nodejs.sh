#!/bin/bash

#root@router:~/git/wat# cat build-nodejs.sh
set -ex

apt update
apt build-dep -y nodejs
apt source nodejs

cd nodejs-20.19.2+dfsg
cat ../v8.patch | ( cd deps/v8 && patch -p1 )

export DEB_BUILD_OPTIONS='parallel=8'
debian/rules binary