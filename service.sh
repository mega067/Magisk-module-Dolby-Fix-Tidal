#!/system/bin/sh
# service.sh

# Magisk module path
MODDIR=${0%/*}

# Wait for boot to complete
while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 1
done

# Restart audio service if needed to apply changes (optional, safe to have)
# killall audioserver
