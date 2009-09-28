#!/bin/bash
# Builds the bootable floppy disk image from the kernel binary
# Parameter $1 -- The name of the kernel binary image
# Parameter $2 -- The name of the boot disk image (output)

# We'd like to use a compressed kernel image
gzip -c "$1" > "$1.gz"

# Update the boot disk image
gzip -cd "./bootfd.img.gz" > "$2"
mcopy -o -i "$2" "$1".gz ./menu.lst ::/boot/

echo "Rebuilt bootable image '$2'"
