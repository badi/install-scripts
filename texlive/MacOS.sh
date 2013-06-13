#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=texlive
VERSION=20130407
URL=http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

curl -L "$URL" | tar zxvf -
cd install-tl-$VERSION

TEXROOT=$PREFIX/$NAME/$VERSION
$SUDO mkdir -pv $TEXROOT
$SUDO TEXLIVE_INSTALL_PREFIX=$TEXROOT ./install-tl -no-gui


modulefile=$MODULEFILES/$NAME/$VERSION
mkdir -p $(dirname $modulefile)
cat <<EOF>$modulefile
#%Module

set name $NAME
set ver  $VERSION
set pref $PREFIX

set root \$pref/\$name/\$ver

prepend-path PATH	\$root/2012/bin/universal-darwin/
prepend-path INFOPATH   \$root/2012/texmf/doc/info
prepend-path MANPATH    \$root/2012/texmf/doc/man
EOF
