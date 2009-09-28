# vim: set ts=4: set sw=4 : set filetype=python : set expandtab : 
src_files = ['src/kernel.c',
             'src/loader.s']
bootfd_img = 'bootfd.img'
kernel_bin = 'kernel.bin'

build_img = Builder(action = './build_img.sh $SOURCE $TARGET')
env = Environment(BUILDERS = {'BuildImg' : build_img})
env['CC'] = './opt/bin/i386-elf-gcc'
env['AS'] = './opt/bin/i386-elf-as'
env['LD'] = './opt/bin/i386-elf-ld'
env['CPPPATH']='src/include'
env['CFLAGS'] = "-ansi -Wall -Werror -nostdlib -nostartfiles -nodefaultlibs"
env['LINKFLAGS'] = "-T linker.ld -nostdlib -nostartfiles"
env.Program(target = kernel_bin, source = src_files)
env.BuildImg(bootfd_img, kernel_bin)
