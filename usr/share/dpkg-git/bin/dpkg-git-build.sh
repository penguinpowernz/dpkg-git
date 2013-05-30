#!/bin/bash

SRCDIR=${1%/}; # remove trailing slash
DEBPATH="$2";

BASENAME="$(basename $SRCDIR)";
TMPDIR="/tmp/dpkg-git/$BASENAME";
CONTROL="$TMPDIR/DEBIAN/control";

# Copy the path to the cache
rm -fr $TMPDIR;
mkdir -p $TMPDIR;
rsync -ra "$SRCDIR/" $TMPDIR --exclude-from="/usr/share/dpkg-git/excludes";

# Check that the control file exists
if ! [ -e "$CONTROL" ]; then
  echo "No control file in $CONTROL";
  echo "Is this even a debian package?";
  exit 1;
fi;

# Get information from the control file
PKGNAME="$(grep 'Package:' $CONTROL|cut -d' ' -f2)";
VERSION="$(grep "Version:" $CONTROL|cut -d' ' -f2)";
ARCH="$(grep "Architec" $CONTROL|cut -d' ' -f2)";

# Move root files to the doc folder
mkdir -p "$TMPDIR/usr/share/doc/$PKGNAME-$VERSION";
find $TMPDIR -maxdepth 1 -type f -exec mv {} "$TMPDIR/usr/share/doc/$PKGNAME-$VERSION" \;

# Change the version in the control file
cat "$CONTROL"|sed "s/^Version: .*$/Version: $VERSION/" > "$CONTROL.new";
mv "$CONTROL.new" "$CONTROL";

# Give the control directory the correct permissions
chmod 755 "$TMPDIR/DEBIAN" -R;

# Build the deb from the directory
DEBNAME="${PKGNAME}_${VERSION}_$ARCH.deb";
[[ $DEBPATH != "" ]] && DEBPATH="$DEBPATH/$DEBNAME";
[[ $DEBPATH = "" ]] && DEBPATH="$(pwd)/$DEBNAME";
dpkg-deb -b $TMPDIR $DEBPATH > /dev/null;
echo $DEBNAME;
