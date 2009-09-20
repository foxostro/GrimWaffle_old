#!/bin/bash
# May need elevated privileges to mount the loop device.
# Expects to be run in the working directory ./GrimWaffle/

# Update the disk image with the latest kernel &c
losetup /dev/loop0 floppy.img
fsck.minix /dev/loop0
mount /dev/loop0 -o loop /media/floppy0
cp menu.lst /media/floppy0/boot/menu.lst
cp kernel.bin /media/floppy0/boot/kernel.bin
umount /media/floppy0
losetup -d /dev/loop0
