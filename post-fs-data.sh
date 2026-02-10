#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# Log start
echo "Dolby Fix Module: post-fs-data started" > /cache/magisk_dolby_fix.log

# Ensure permissions
chmod 755 $MODDIR/system/vendor/bin/hw/vendor.dolby.hardware.dms@2.0-service
chmod 644 $MODDIR/system/vendor/etc/media_codecs_dolby_audio.xml
chmod 644 $MODDIR/system/vendor/lib/hw/sound_trigger.primary.msmnile.so
chmod 644 $MODDIR/system/odm/lib/liba2dpoffload.so
chmod 644 $MODDIR/system/odm/lib/libaudioEngineerTest.so
chmod 644 $MODDIR/system/vendor/lib/libhdmipassthru.so
chmod 644 $MODDIR/system/vendor/lib/libssrec.so
chmod 644 $MODDIR/system/vendor/lib64/vendor.dolby.hardware.dms@2.0-impl.so
chmod 644 $MODDIR/system/vendor/lib64/vendor.dolby.hardware.dms@2.0.so
chmod 644 $MODDIR/system/vendor/etc/init/vendor.dolby.hardware.dms@2.0-service.rc

echo "Dolby Fix Module: permissions set for Android 15 binaries" >> /cache/magisk_dolby_fix.log
