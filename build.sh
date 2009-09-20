#!/bin/bash
AS=/opt/cross/bin/i386-elf-as
CC=/opt/cross/bin/i386-elf-gcc
LD=/opt/cross/bin/i386-elf-ld

$AS -o loader.o loader.s
$CC -o kernel.o -c kernel.c -Wall -Werror -ansi -nostdlib -nostartfiles -nodefaultlibs
$LD -T linker.ld -o kernel.bin loader.o kernel.o

gzip kernel.bin

# Update the boot disk image
gzip -cd ./bootfd.img.gz > ./bootfd.img
mcopy -o -i ./bootfd.img ./kernel.bin.gz ./menu.lst ::/boot/
