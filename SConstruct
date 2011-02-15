# vim: et: ts=4: sw=4: filetype=python:
import os


bootfd_img = 'bootfd.img'
kernel_bin = 'kernel.bin'
src_c_files = Split("""
src/kernel.c
src/seg.c
src/idt.c
""")
src_asm_files = Split("""
src/boot.S
src/asm.S
""")
src_files = src_c_files + src_asm_files
src_test_files = src_c_files + ['src/test_mock_asm.c', 'src/test.c']


if 'check' in COMMAND_LINE_TARGETS:
    # Units tests
    env = Environment(ENV=os.environ)
    env['CPPPATH']='src/include'
    env['CFLAGS'] = "-ansi -Wall -Werror -DUNIT_TEST -fno-builtin"
    test = env.Program(target = "test",
                       LIBS=['cunit'],
                       source = src_test_files)
    env.Alias('check', test)
    env.AlwaysBuild(test)
    env.AddPostAction(test, "./test")
else:
    # The kernel itself
    build_img = Builder(action = './build_img.sh $SOURCE $TARGET')
    env = Environment(BUILDERS = {'BuildImg' : build_img})
    env['CC'] = '/opt/local/bin/i386-elf-gcc-4.3.2'
    env['CPPPATH']='src/include'
    env['CFLAGS'] = "-ansi -Wall -Werror -nostdlib -nostartfiles -nodefaultlibs -fno-builtin"
    env['LINKFLAGS'] = "-T linker.ld -nostdlib -nostartfiles"
    env.Program(target = kernel_bin, source = src_files)
    env.BuildImg(bootfd_img, kernel_bin)

