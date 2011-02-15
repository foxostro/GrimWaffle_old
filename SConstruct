# vim: set ts=4: set sw=4 : set filetype=python : set expandtab : 
import os

src_files = ['src/boot.S',
			 'src/kernel.c',
			 'src/seg.c',
			 'src/idt.c',
			 'src/asm.S']
bootfd_img = 'bootfd.img'
kernel_bin = 'kernel.bin'

build_img = Builder(action = './build_img.sh $SOURCE $TARGET')
env = Environment(ENV=os.environ, BUILDERS = {'BuildImg' : build_img})
env['CC'] = '/opt/local/bin/i386-elf-gcc-4.3.2'
env['CPPPATH']='src/include'
env['CFLAGS'] = "-ansi -Wall -Werror -nostdlib -nostartfiles -nodefaultlibs -fno-builtin"
env['LINKFLAGS'] = "-T linker.ld -nostdlib -nostartfiles"
env.Program(target = kernel_bin, source = src_files)
env.BuildImg(bootfd_img, kernel_bin)
