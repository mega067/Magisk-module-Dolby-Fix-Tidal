#!/bin/bash
# download_files.sh
# Downloads proprietary Dolby files for sm8150

BASE_URL="https://raw.githubusercontent.com/QuinceROMs/vendor_oneplus_sm8150-common-1/16-d/proprietary/vendor"
OUTPUT_DIR="system/vendor"

# Function to download a file
download_file() {
    local PATH_SUFFIX=$1
    local URL="$BASE_URL/$PATH_SUFFIX"
    local DEST="$OUTPUT_DIR/$PATH_SUFFIX"
    local DIRNAME=$(dirname "$DEST")

    echo "Downloading $PATH_SUFFIX..."
    mkdir -p "$DIRNAME"
    
    # Use curl with -f to fail silently on server errors (404), helping us detect missing files
    if curl -s -f -L -o "$DEST" "$URL"; then
        echo "  -> Success: $DEST"
    else
        echo "  -> Error: Could not download $URL"
        # Remove empty file if curl touched it
        rm -f "$DEST"
    fi
}

echo "Starting download of Dolby specific files..."

# Binaries
download_file "bin/hw/vendor.dolby.hardware.dms@2.0-service"
chmod 755 "$OUTPUT_DIR/bin/hw/vendor.dolby.hardware.dms@2.0-service"

# Init configuration
download_file "etc/init/vendor.dolby.hardware.dms@2.0-service.rc"
download_file "etc/vintf/manifest/manifest_vendor.dolby.hardware.dms.xml"

# Libs (32-bit)
download_file "lib/libdapparamstorage.so"
download_file "lib/libdeccfg.so"
download_file "lib/libstagefright_soft_ac4dec.so"
download_file "lib/libstagefright_soft_ddpdec.so"
download_file "lib/soundfx/libswdap.so"
download_file "lib/soundfx/libswgamedap.so"
download_file "lib/soundfx/libswvqe.so"
download_file "lib/vendor.dolby.hardware.dms@2.0.so"
download_file "lib/libstagefright_foundation-v33.so" # New dependency

# Libs (64-bit)
download_file "lib64/libdapparamstorage.so"
download_file "lib64/libdlbdsservice.so"
download_file "lib64/vendor.dolby.hardware.dms@2.0-impl.so"
download_file "lib64/vendor.dolby.hardware.dms@2.0.so"
# download_file "lib64/libstagefright_foundation-v33.so" # FIXME: Not found in proprietary files. Ensure it's present in system or find source.

# Configs
# Download full media_codecs_c2.xml from device tree (not vendor blobs) as it contains all codecs including Dolby
curl -s -f -L -o "$OUTPUT_DIR/etc/media_codecs_c2.xml" "https://raw.githubusercontent.com/QuinceROMs/device_oneplus_sm8150-common-1/16-d/configs/media/media_codecs_c2.xml"
if [ -s "$OUTPUT_DIR/etc/media_codecs_c2.xml" ]; then
    echo "  -> Success: system/vendor/etc/media_codecs_c2.xml"
else
    echo "  -> Error: Could not download media_codecs_c2.xml"
fi

echo "Download complete."
