#!/bin/bash
rm grub_boot_floppy.img
rm floppy.img

# Create a disk image that can boot to the Grub console
dd if=stage1 of=grub_boot_floppy.img bs=512 count=1
dd if=stage2 of=grub_boot_floppy.img bs=512 seek=1

# Create a disk image with the desired file structure
dd if=/dev/zero of=floppy.img bs=1 count=1474560
sudo losetup /dev/loop0 floppy.img
sudo mkfs.minix /dev/loop0
sudo fsck.minix /dev/loop0
sudo mount /dev/loop0 -o loop /media/floppy0
sudo mkdir /media/floppy0/boot
sudo cp ../menu.lst /media/floppy0/boot/menu.lst
sudo cp stage1 /media/floppy0/boot/stage1
sudo cp stage2 /media/floppy0/boot/stage2
sudo cp ../kernel.bin /media/floppy0/boot/kernel.bin
sudo umount /media/floppy0
sudo losetup -d /dev/loop0

# Next step is to make the 2nd image bootable, which is a manual process
echo "Now we need to install grub on the floppy disk image. This process is "
echo "manually."
echo "STEPS:"
echo "    1. Use Bochs to boot grub_boot_floppy.img"
echo "    2. At the Grub console, have Bochs eject the floppy and insert the "
echo "       floppy.img disk image in its place."
echo "    3. At the Grub console, run this command 'install (fd0)/boot/stage1 (fd0) (fd0)/boot/stage2 (fd0)/boot/menu.'"
echo "    4. Quit Bochs"
echo "    5. Now you can continue to use and update floppy.img by mounting as"
echo "       a loop-back device."
