#!/system/bin/sh
MODDIR=${0%/*}

# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

# Verify if property is set
PROP_VAL=$(getprop ro.vendor.audio.dolby.dax.support)
echo "Dolby Fix Module: ro.vendor.audio.dolby.dax.support is $PROP_VAL" >> /cache/magisk_dolby_fix.log

# Verify if XML is visible
if [ -f /vendor/etc/media_codecs_dolby_audio.xml ]; then
  echo "Dolby Fix Module: /vendor/etc/media_codecs_dolby_audio.xml exists" >> /cache/magisk_dolby_fix.log
else
  echo "Dolby Fix Module: /vendor/etc/media_codecs_dolby_audio.xml NOT found" >> /cache/magisk_dolby_fix.log
fi

# Fix missing libaudioroute-v34.so (Workaround)
# Bind mount system/vendor libaudioroute.so to our dummy v34 file
if [ -f /vendor/lib/libaudioroute.so ]; then
    mount -o bind /vendor/lib/libaudioroute.so $MODDIR/system/vendor/lib/libaudioroute-v34.so
fi
if [ -f /vendor/lib64/libaudioroute.so ]; then
    mount -o bind /vendor/lib64/libaudioroute.so $MODDIR/system/vendor/lib64/libaudioroute-v34.so
fi

# Fix missing libstagefright_foundation-v33.so (Workaround)
# Bind mount system libstagefright_foundation.so to our dummy v33 file
# Try finding it in system/lib64 or vendor/lib64
STAGEFRIGHT_LIB=""
if [ -f /system/lib64/libstagefright_foundation.so ]; then
    STAGEFRIGHT_LIB="/system/lib64/libstagefright_foundation.so"
elif [ -f /vendor/lib64/libstagefright_foundation.so ]; then
    STAGEFRIGHT_LIB="/vendor/lib64/libstagefright_foundation.so"
fi

if [ ! -z "$STAGEFRIGHT_LIB" ]; then
    mount -o bind "$STAGEFRIGHT_LIB" $MODDIR/system/vendor/lib64/libstagefright_foundation-v33.so
    echo "Dolby Fix Module: Bind mounted $STAGEFRIGHT_LIB to libstagefright_foundation-v33.so (64-bit)" >> /cache/magisk_dolby_fix.log
else
    echo "Dolby Fix Module: CRITICAL - libstagefright_foundation.so (64-bit) NOT FOUND" >> /cache/magisk_dolby_fix.log
fi

# 32-bit workaround
STAGEFRIGHT_LIB_32=""
if [ -f /system/lib/libstagefright_foundation.so ]; then
    STAGEFRIGHT_LIB_32="/system/lib/libstagefright_foundation.so"
elif [ -f /vendor/lib/libstagefright_foundation.so ]; then
    STAGEFRIGHT_LIB_32="/vendor/lib/libstagefright_foundation.so"
fi

if [ ! -z "$STAGEFRIGHT_LIB_32" ]; then
    mount -o bind "$STAGEFRIGHT_LIB_32" $MODDIR/system/vendor/lib/libstagefright_foundation-v33.so
    echo "Dolby Fix Module: Bind mounted $STAGEFRIGHT_LIB_32 to libstagefright_foundation-v33.so (32-bit)" >> /cache/magisk_dolby_fix.log
else
    echo "Dolby Fix Module: CRITICAL - libstagefright_foundation.so (32-bit) NOT FOUND" >> /cache/magisk_dolby_fix.log
fi

# Restart Audioserver to load new configs
# Usually not needed if module is installed via Magisk (reboot required anyway), 
# but good for ensuring runtime changes if applied hot.
# However, since this is a Magisk module that requires reboot, the main thing is ensuring files are in place.
# The 'service.sh' runs late_start, so audioserver is already running.
# If we modified props or mounts, a restart might help, but can be risky.
# Let's just log for now.

# Check if dms service is running
if pgrep -f "vendor.dolby.hardware.dms@2.0-service" > /dev/null; then
    echo "Dolby Fix Module: DMS Service is running" >> /cache/magisk_dolby_fix.log
else
    echo "Dolby Fix Module: DMS Service is NOT running. Attempting start..." >> /cache/magisk_dolby_fix.log
    start dms-hal-2-0
fi
