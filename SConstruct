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
    env.AlwaysBuild(test)

    # If we run ./test with AddPostAction() then scons reports a false
    # dependency cycle. Instead, invoke from a target that depends on ./test
    check = env.Command("check", test, test[0].abspath)
    env.Depends(check, test)
else:
    # The kernel itself
    build_img = Builder(action = './build_img.sh $SOURCE $TARGET')
    env = Environment(BUILDERS = {'BuildImg' : build_img})
    env['CPPPATH']='src/include'
    env['CFLAGS'] = "-m32 -ansi -Wall -Werror -nostdlib -nostartfiles -nodefaultlibs -fno-builtin"
    env['ASFLAGS'] = "-m32 -Wall -Werror -nostdlib -nostartfiles -nodefaultlibs -fno-builtin"
    env['LINKFLAGS'] = "-melf -m32 -T linker.ld -nostdlib -nostartfiles"
    env.Program(target = kernel_bin, source = src_files)
    env.BuildImg(bootfd_img, kernel_bin)

