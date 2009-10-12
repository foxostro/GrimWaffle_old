#!/bin/bash

BASE="`pwd`/.."
WD="$BASE/bootstrap"
PREFIX="$BASE/opt"
TARGET="i386-elf"

##############################################################################

function fetch_scons
{
	URL=http://softlayer.dl.sourceforge.net/project/scons/scons/1.2.0/scons-1.2.0.tar.gz
	MD5=53b6aa7281811717a57598e319441cf7
	lazy_fetch $URL $MD5
}

##############################################################################

function fetch_bochs
{
	URL=http://softlayer.dl.sourceforge.net/project/bochs/bochs/2.4.1/bochs-2.4.1.tar.gz
	MD5=c9aaf4b99c868da7c9362bd8cd29a578
	lazy_fetch $URL $MD5
}

##############################################################################

function fetch_mtools
{
	URL=http://distfiles.macports.org/mtools/mtools-3.9.11.tar.gz
	MD5=3c0ae05b0d98a5d3bd06d3d72fcaf80d
	lazy_fetch $URL $MD5
}

##############################################################################

function fetch_binutils
{
	URL=http://mirrors.kernel.org/gnu/binutils/binutils-2.19.1.tar.bz2
	MD5=09a8c5821a2dfdbb20665bc0bd680791
	lazy_fetch $URL $MD5
}

##############################################################################

function fetch_gmp
{
	URL=ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.1.tar.bz2
	MD5=26cec15a90885042dd4a15c4003b08ae
	lazy_fetch $URL $MD5
}

##############################################################################

function fetch_mpfr
{
	URL=http://www.mpfr.org/mpfr-current/mpfr-2.4.1.tar.bz2
	MD5=c5ee0a8ce82ad55fe29ac57edd35d09e
	lazy_fetch $URL $MD5
}

##############################################################################

function fetch_gcc
{
	URL=http://ftp.gnu.org/gnu/gcc/gcc-4.4.1/gcc-core-4.4.1.tar.bz2
	MD5=d19693308aa6b2052e14c071111df59f
	lazy_fetch $URL $MD5
}

##############################################################################

function build_scons
{
	PKG=scons-1.2.0.tar.gz
	tar -xzvf $PKG
	pushd scons-1.2.0
	python setup.py install --prefix=$PREFIX
	popd # scons-1.2.0
}
	
##############################################################################

function build_bochs
{
	PKG=bochs-2.4.1.tar.gz
	tar -xzvf $PKG
	
	# Build
	pushd bochs-2.4.1
	if [ `uname` == "Darwin" ] ; then
		./configure --prefix=$PREFIX \
        		    --enable-smp \
					--enable-cpu-level=6 \
					--enable-acpi \
					--enable-all-optimizations \
					--enable-x86-64 \
					--enable-pci \
					--enable-apic \
					--enable-vmx \
					--enable-pae \
					--enable-large-pages \
					--enable-debugger \
					--enable-disasm \
					--enable-debugger-gui \
					--enable-logging \
					--enable-vbe \
					--enable-fpu \
					--enable-mmx \
					--enable-3dnow \
					--enable-sb16=dummy \
					--enable-sep \
					--enable-x86-debugger \
					--enable-iodebug \
					--disable-plugins \
					--disable-docbook \
					--with-term
	else
		./configure --prefix=$PREFIX \
        		    --enable-smp \
					--enable-cpu-level=6 \
					--enable-acpi \
					--enable-all-optimizations \
					--enable-x86-64 \
					--enable-pci \
					--enable-apic \
					--enable-vmx \
					--enable-pae \
					--enable-large-pages \
					--enable-debugger \
					--enable-disasm \
					--enable-debugger-gui \
					--enable-logging \
					--enable-vbe \
					--enable-fpu \
					--enable-mmx \
					--enable-3dnow \
					--enable-sb16=dummy \
					--enable-sep \
					--enable-x86-debugger \
					--enable-iodebug \
					--disable-plugins \
					--disable-docbook \
					--with-x --with-x11 --with-term
	fi
	make all install
	popd # bochs-2.4.1
}

##############################################################################

function build_binutils
{
	PKG=binutils-2.19.1.tar.bz2
	
	tar -xjvf $PKG
	
	pushd binutils-2.19.1
	# Configure with --disable-werror so it builds on Mac OS X
	./configure --target=$TARGET \
	            --prefix=$PREFIX \
	            --disable-nls \
				--disable-werror
	make
	make install
	popd # binutils-2.19.1
}

##############################################################################

function build_mtools
{
	PKG=mtools-3.9.11.tar.gz
	
	tar -xzvf $PKG
	
	pushd mtools-3.9.11
	./configure --prefix=$PREFIX
	make
	make install
	popd # mtools-3.9.11
}

##############################################################################

function build_gcc
{
	tar -xjvf gcc-core-4.4.1.tar.bz2
	
	# Get GMP
	tar -xjvf gmp-4.3.1.tar.bz2
	mkdir -p gcc-4.4.1
	mv gmp-4.3.1 gcc-4.4.1/gmp
	
	# Get MPFR
	tar -xjvf mpfr-2.4.1.tar.bz2
	mkdir -p gcc-4.4.1
	mv mpfr-2.4.1 gcc-4.4.1/mpfr
	
	# Build GCC
	pushd gcc-4.4.1
	./configure --target=$TARGET \
	            --prefix=$PREFIX \
				--disable-nls \
				--enable-languages=c \
				--without-headers
	make all-gcc install-gcc
	popd # gcc-4.4.1
}

##############################################################################
##############################################################################
##############################################################################

# We'll do all all work here so as to not clutter the project folder.
cd $WD

# Option to just clean out all the work done bootstrapping.
if [ "$1" == "--clean" ] ; then
	# With clean, we DO NOT delete packages that were downloaded
	rm -rf scons-1.2.0
	rm -rf bochs-2.4.1
	rm -rf binutils-2.19.1
	rm -rf gcc-4.4.1
	rm -rf "$PREFIX"
	exit 0
elif [ "$1" == "--purge" ] ; then
	rm -f scons-1.2.0.tar.gz
	rm -f bochs-2.4.1.tar.gz
	rm -f binutils-2.19.1.tar.bz2
	rm -f gmp-4.3.1.tar.bz2
	rm -f mpfr-2.4.1.tar.bz2
	rm -f gcc-core-4.4.1.tar.bz2
	rm -rf scons-1.2.0
	rm -rf bochs-2.4.1
	rm -rf binutils-2.19.1
	rm -rf gcc-4.4.1
	rm -rf "$PREFIX"
	exit 0
elif [ "$1" == "--fetch" ] ; then
	fetch_scons
	fetch_bochs
	fetch_mtools
	fetch_binutils
	fetch_gmp
	fetch_mpfr
	fetch_gcc
	echo "Done fetching packages"
	exit 0
elif [ "$1" == "--build" ] ; then
	# We'll put prereq libraries in here
	mkdir -p $PREFIX
	build_scons
	build_bochs
	build_mtools
	build_binutils
	build_gcc
	echo "Done. Prereqs installed in '$PREFIX'"
	exit 0
fi
