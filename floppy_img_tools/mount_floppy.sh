#!/bin/sh
sudo losetup /dev/loop0 floppy.img
sudo mount /dev/loop0 -o loop /media/floppy0
