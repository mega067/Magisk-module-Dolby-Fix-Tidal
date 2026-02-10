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
