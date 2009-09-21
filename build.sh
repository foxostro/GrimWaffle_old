#!/bin/bash
AS=./opt/bin/i386-elf-as
CC=./opt/bin/i386-elf-gcc
LD=./opt/bin/i386-elf-ld

$AS -o loader.o loader.s
$CC -o kernel.o -c kernel.c -Wall -Werror -ansi -nostdlib -nostartfiles -nodefaultlibs
$LD -T linker.ld -o kernel.bin loader.o kernel.o

# We'd like to use a compressed kernel image
gzip -c kernel.bin > kernel.bin.gz

# Update the boot disk image
gzip -cd ./bootfd.img.gz > ./bootfd.img
mcopy -o -i ./bootfd.img ./kernel.bin.gz ./menu.lst ::/boot/
