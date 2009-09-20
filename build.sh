#!/bin/bash
AS=/opt/cross/bin/i386-elf-as
CC=/opt/cross/bin/i386-elf-gcc
LD=/opt/cross/bin/i386-elf-ld

$AS -o loader.o loader.s
$CC -o kernel.o -c kernel.c -Wall -Werror -ansi -nostdlib -nostartfiles -nodefaultlibs
$LD -T linker.ld -o kernel.bin loader.o kernel.o

# Grab a clean disk image
cp ./floppy_img_tools/floppy.img.backup ./floppy.img

# Updating the disk image requires the loop device requires root.
echo "Updating floppy.img through the loop device (need root for this)..."
sudo bash ./floppy_img_tools/build_floppy_img.sh
