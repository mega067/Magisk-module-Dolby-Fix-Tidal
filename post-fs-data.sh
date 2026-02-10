#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# Log start
echo "Dolby Fix Module: post-fs-data started" > /cache/magisk_dolby_fix.log

# Ensure permissions (just in case)
chmod 644 $MODDIR/system/vendor/etc/media_codecs_dolby_audio.xml

echo "Dolby Fix Module: permissions set" >> /cache/magisk_dolby_fix.log
