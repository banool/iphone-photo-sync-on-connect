# iPhone photo sync on connect

## Setup: Run manually
First, make sure you have rsync and ifuse. You can get rsync from brew easily enough, but getting ifuse to work is a bit tricky. See here: https://sudonull.com/post/25455-Mount-iOS-under-OSX-using-ifuse.

First off, cp the syncing script into the **parent** directory of the location where you want the photos to sync to:

```
cp iphone_photo_sync.sh gdrive/pictures
```

Next, make sure to set `DESTINATION` in the copied `iphone_photo_sync.sh` to the destination directory you want to sync the photos into. `DESTINATION` is relative to the location of `iphone_photo_sync.sh`.

## Setup: Trigger automatically
First, do the manual stuff above. Now at this point, you can run the sync script manually, but to do it automatically, follow these steps:

Build xpc_set_event_stream_handler and put it in place:
```
cd ~/github
git clone git@github.com:himbeles/mac-device-connect-daemon.git
gcc -framework Foundation -o xpc_set_event_stream_handler xpc_set_event_stream_handler.m
cp set_event_stream_handler /usr/local/bin/
```

This makes sure that our plist, which we install later, only runs once on connect.

Next, create a symlink to the script in the sync location in /usr/local/bin:
```
ln -s /Users/dport/gdrive/pictures/iphone_photo_sync.sh /usr/local/bin/iphone_photo_sync
```

Next we need to modify the plist so that `idVendor` and `idProduct` are correct. Follow the README here for guidance: https://github.com/himbeles/mac-device-connect-daemon.

Finally, install the plist:
```
cp com.iphonephotosync.plist /Library/LaunchDemons
sudo chown root:wheel /Library/LaunchDaemons/com.iphonephotosync.plist
launchctl load /Library/LaunchDaemons/com.iphonephotosync.plist
```


