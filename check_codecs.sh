#!/bin/bash
# check_codecs.sh

echo "Checking for Dolby codecs on device..."

# Check if device is connected
adb wait-for-device

echo "--- Dumpsys Media Player Check ---"
# Check if media.player service knows about the codecs (requires reboot to take effect)
adb shell "dumpsys media.player -m | grep -iE 'dolby|ac4|eac3'"

echo ""
echo "--- Service Check ---"
# Check if the Dolby service is running
adb shell "service list | grep -i dolby"

echo ""
echo "--- Property Check ---"
adb shell "getprop | grep -i dolby"

echo ""
echo "If you see 'c2.dolby.client.ac4.decoder' and 'c2.dolby.client.eac3.decoder' in the output above, verification passed!"
echo "If the service 'vendor.dolby.hardware.dms' is found, the binary is running correctly."
