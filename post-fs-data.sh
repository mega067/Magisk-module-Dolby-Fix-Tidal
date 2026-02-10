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
chmod 644 $MODDIR/system/vendor/lib64/vendor.dolby.hardware.dms@2.0.so
chmod 644 $MODDIR/system/vendor/etc/init/vendor.dolby.hardware.dms@2.0-service.rc
chmod 644 $MODDIR/system/vendor/lib/libstagefright_soft_ac4dec.so
chmod 644 $MODDIR/system/vendor/lib/libstagefright_soft_ddpdec.so
chmod 644 $MODDIR/system/vendor/lib/libdapparamstorage.so
chmod 644 $MODDIR/system/vendor/lib/libdeccfg.so
chmod 644 $MODDIR/system/vendor/lib/soundfx/libswdap.so
chmod 644 $MODDIR/system/vendor/lib/soundfx/libswgamedap.so
chmod 644 $MODDIR/system/vendor/lib/soundfx/libswvqe.so
chmod 644 $MODDIR/system/vendor/lib64/libdapparamstorage.so
chmod 644 $MODDIR/system/vendor/lib64/libdlbdsservice.so

# Create dummy file for libaudioroute-v34.so if not exists, so we can mount over it later
touch $MODDIR/system/vendor/lib/libaudioroute-v34.so
chmod 644 $MODDIR/system/vendor/lib/libaudioroute-v34.so
touch $MODDIR/system/vendor/lib64/libaudioroute-v34.so
chmod 644 $MODDIR/system/vendor/lib64/libaudioroute-v34.so

# Workaround for libstagefright_foundation-v33.so (Required by dms-service)
# We map the system's current libstagefright_foundation.so to the v33 name.
touch $MODDIR/system/vendor/lib64/libstagefright_foundation-v33.so
chmod 644 $MODDIR/system/vendor/lib64/libstagefright_foundation-v33.so
touch $MODDIR/system/vendor/lib/libstagefright_foundation-v33.so
chmod 644 $MODDIR/system/vendor/lib/libstagefright_foundation-v33.so

# CRITICAL: Mount NOW in post-fs-data so the service sees it immediately on start
# 64-bit mount
if [ -f /system/lib64/libstagefright_foundation.so ]; then
    mount -o bind /system/lib64/libstagefright_foundation.so $MODDIR/system/vendor/lib64/libstagefright_foundation-v33.so
elif [ -f /vendor/lib64/libstagefright_foundation.so ]; then
    mount -o bind /vendor/lib64/libstagefright_foundation.so $MODDIR/system/vendor/lib64/libstagefright_foundation-v33.so
fi

# 32-bit mount
if [ -f /system/lib/libstagefright_foundation.so ]; then
    mount -o bind /system/lib/libstagefright_foundation.so $MODDIR/system/vendor/lib/libstagefright_foundation-v33.so
elif [ -f /vendor/lib/libstagefright_foundation.so ]; then
    mount -o bind /vendor/lib/libstagefright_foundation.so $MODDIR/system/vendor/lib/libstagefright_foundation-v33.so
fi

# Also mount libaudioroute-v34 here
if [ -f /vendor/lib/libaudioroute.so ]; then
    mount -o bind /vendor/lib/libaudioroute.so $MODDIR/system/vendor/lib/libaudioroute-v34.so
fi
if [ -f /vendor/lib64/libaudioroute.so ]; then
    mount -o bind /vendor/lib64/libaudioroute.so $MODDIR/system/vendor/lib64/libaudioroute-v34.so
fi

echo "Dolby Fix Module: permissions, dummy files AND MOUNTS set in post-fs-data" >> /cache/magisk_dolby_fix.log
