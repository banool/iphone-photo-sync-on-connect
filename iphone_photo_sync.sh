#!/usr/local/bin/bash
# You must have rsync and ifuse.
# Getting a working version of ifuse is a bit tricky:
# https://sudonull.com/post/25455-Mount-iOS-under-OSX-using-ifuse
# The DESTINATION directory is relative.

# Note: I have this set up to run automatically now, see:
# /Library/LaunchDaemons/com.iphonesync.plist
# https://github.com/himbeles/mac-device-connect-daemon

set -e

cd "$(dirname "$(readlink "$0")")"

MOUNTPOINT=`mktemp -d -t iphonesync`
DESTINATION="Camera Uploads 2021-01-12 onward iPhone FUSE rsync"

echo "Temporary directory for mount point: $MOUNTPOINT"
echo "Destination directory: $DESTINATION"

sleep 5

/usr/local/bin/ifuse $MOUNTPOINT

/usr/local/bin/rsync -av $MOUNTPOINT/DCIM/ "$DESTINATION"

umount $MOUNTPOINT
