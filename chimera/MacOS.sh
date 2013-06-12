#!/usr/bin/env bash

globals=$( cd $(dirname $0); pwd)/../globals.sh
source $globals

NAME=chimera
VERSION=1.8
URL_ARCH=mac64
URL="https://www.rbvi.ucsf.edu/chimera/cgi-bin/secure/chimera-get.py"
DMG="$NAME-$VERSION-${URL_ARCH}.dmg"
DEST=/Applications
VOL=/Volumes/ChimeraInstaller
VAPP=Chimera.app
MAPP=Chimera-$VERSION.app

curl \
    -d ident=SomethingDynamic \
    -d file=${URL_ARCH}/$DMG \
    -d choice=Accept \
    "$URL" \
    > $DMG

# Useful documentation:
# http://commandlinemac.blogspot.com/2008/12/installing-dmg-application-from-command.html
hdiutil mount "$DMG"
echo "Installing $NAME"
cp -a "$VOL/$VAPP" "$DEST/$MAPP"
hdiutil unmount "$VOL"


modulefile=$MODULEFILES/$NAME/$VERSION
mkdir -p $(dirname $modulefile)
cat <<EOF>$modulefile
#%Module

set pref $DEST/$MAPP

set root \$pref/Contents/Resources

prepend-path PATH               \$root/bin
EOF
