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
if [ ! -f /vendor/lib/libaudioroute-v34.so ] && [ -f /vendor/lib/libaudioroute.so ]; then
    mount -o bind /vendor/lib/libaudioroute.so /vendor/lib/libaudioroute-v34.so
    echo "Dolby Fix Module: Bind mounted libaudioroute.so to libaudioroute-v34.so" >> /cache/magisk_dolby_fix.log
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
