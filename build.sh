#!/bin/bash
AS=/opt/cross/bin/i386-elf-as
CC=/opt/cross/bin/i386-elf-gcc
LD=/opt/cross/bin/i386-elf-ld

$AS -o loader.o loader.s
$CC -o kernel.o -c kernel.c -Wall -Werror -ansi -nostdlib -nostartfiles -nodefaultlibs
$LD -T linker.ld -o kernel.bin loader.o kernel.o

sudo losetup /dev/loop0 floppy.img
sudo fsck.minix /dev/loop0
sudo mount /dev/loop0 -o loop /media/floppy0
sudo cp menu.lst /media/floppy0/boot/menu.lst
sudo cp kernel.bin /media/floppy0/boot/kernel.bin
sudo umount /media/floppy0
sudo losetup -d /dev/loop0
