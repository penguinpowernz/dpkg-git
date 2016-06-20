#!/bin/bash

srcdir=${1%/}; # remove trailing slash
debpath="$2";

basename="$(basename $srcdir)";
tmpdir="/tmp/dpkg-git/$basename";
control="$tmpdir/DEBIAN/control";

# Copy the path to the cache
rm -fr $tmpdir;
mkdir -p $tmpdir;
rsync -ra "$srcdir/" $tmpdir --exclude-from="/usr/share/dpkg-git/excludes";

# Check that the control file exists
if ! [ -e "$control" ]; then
  echo "No control file in $control";
  echo "Is this even a debian package?";
  exit 1;
fi;

# Get information from the control file
pkgname="$(grep 'Package:' $control|cut -d' ' -f2)";
version="$(grep "Version:" $control|cut -d' ' -f2)";
arch="$(grep "Architec" $control|cut -d' ' -f2)";

# Move root files to the doc folder
mkdir -p "$tmpdir/usr/share/doc/$pkgname-$version";
find $tmpdir -maxdepth 1 -type f -exec mv {} "$tmpdir/usr/share/doc/$pkgname-$version" \;

# Change the version in the control file
cat "$control"|sed "s/^Version: .*$/Version: $version/" > "$control.new";
mv "$control.new" "$control";

# Give the control directory the correct permissions
chmod 755 "$tmpdir/DEBIAN" -R;

# Build the deb from the directory
DEBNAME="${pkgname}_${version}_$arch.deb";
[[ $debpath != "" ]] && debpath="$debpath/$DEBNAME";
[[ $debpath = "" ]] && debpath="$(pwd)/$DEBNAME";
dpkg-deb -b $tmpdir $debpath > /dev/null;
echo $DEBNAME;
