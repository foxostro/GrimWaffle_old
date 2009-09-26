#!/bin/bash

BASE="`pwd`/.."
WD="$BASE/bootstrap"
PREFIX="$BASE/opt"
TARGET="i386-elf"

##############################################################################

function check_md5
{
	PKG_FILE="$1"
	MD5_FILE="$2"

	if [ -f "$MD5_FILE" ] ; then
		echo "MD5 file seems to be present"
	else
		echo "MD5 file seems to be missing: '$MD5_FILE'"
		exit -1
	fi

	if [ -f "$PKG_FILE" ] ; then
		echo "Going to check '$PKG_FILE'"
	else
		echo "File seems to be missing: '$PKG_FILE'"
		return 1
	fi

	if [ `uname` == "Darwin" ] ; then
		CALCULATED=`md5 -q "$PKG_FILE"`
		EXPECTED=`sed -E 's/^([0-9a-f]+) .*$/\1/' "$MD5_FILE"`
		
		if [ "$CALCULATED" == "$EXPECTED" ] ; then
			return 0
		else
			return 1
		fi
	else
		md5sum --check "$MD5_FILE" --status
		return $?
	fi
}

##############################################################################

function lazy_fetch
{
	URL="$1"
	PKG_FILE="$2"
	MD5_FILE="$3"
	
	# Have we already downloaded it already?
	check_md5 "$PKG_FILE" "$MD5_FILE"

	if [ $? -ne 0 ] ; then
		echo "Downloading <$URL>..."
		curl -O $URL
		if [ $? -ne 0 ] ; then
			echo "Failed to download file at <$URL>"
			exit -1
		fi

		# Check the hash on the finished download
		check_md5 "$PKG_FILE" "$MD5_FILE"
		if [ $? -ne 0 ] ; then
			echo "Downloaded '$PKG_FILE', but the MD5 hash looks WRONG."
			exit -1
		fi
	else
		echo "Already downloaded '$PKG_FILE' and the MD5 hash looks OK."
	fi
}

##############################################################################

function get_scons
{
	URL=http://softlayer.dl.sourceforge.net/project/scons/scons/1.2.0/scons-1.2.0.tar.gz
	PKG=scons-1.2.0.tar.gz
	MD5=md5s/scons-1.2.0.tar.gz.md5
	
	echo "Getting SCons 1.2.0"
	lazy_fetch $URL $PKG $MD5
	tar -xzvf $PKG
	pushd scons-1.2.0
	python setup.py install --prefix=$PREFIX
	popd # scons-1.2.0
}
	
##############################################################################

function get_bochs
{
	URL=http://softlayer.dl.sourceforge.net/project/bochs/bochs/2.4.1/bochs-2.4.1.tar.gz
	PKG=bochs-2.4.1.tar.gz
	MD5=md5s/bochs-2.4.1.tar.gz.md5
	
	# Fetch and extract
	echo "Getting Bochs 2.4.1"
	lazy_fetch $URL $PKG $MD5
	tar -xzvf $PKG
	
	# Build
	pushd bochs-2.4.1
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
	make all install
	popd # bochs-2.4.1
}

##############################################################################

function get_binutils
{
	URL=http://mirrors.kernel.org/gnu/binutils/binutils-2.19.1.tar.bz2
	PKG=binutils-2.19.1.tar.bz2
	MD5=md5s/binutils-2.19.1.tar.bz2.md5
	
	# Fetch and extract
	echo "Getting binutils-2.19.1"
	lazy_fetch $URL $PKG $MD5
	tar -xjvf $PKG
	
	# Build
	pushd binutils-2.19.1
	./configure --target=$TARGET --prefix=$PREFIX --disable-nls && \
	  make && \
	  make install
	popd # binutils-2.19.1
}

##############################################################################

function get_gmp
{
	URL=ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.1.tar.bz2
	PKG=gmp-4.3.1.tar.bz2
	MD5=md5s/gmp-4.3.1.tar.bz2.md5
	
	# Fetch and extract
	echo "Getting gmp-4.3.1"
	lazy_fetch $URL $PKG $MD5
	tar -xjvf $PKG
	
	# Move so we build with GCC
	mkdir -p gcc-4.4.1
	mv gmp-4.3.1 gcc-4.4.1/gmp
}

##############################################################################

function get_mpfr
{
	URL=http://www.mpfr.org/mpfr-current/mpfr-2.4.1.tar.bz2
	PKG=mpfr-2.4.1.tar.bz2
	MD5=md5s/mpfr-2.4.1.tar.bz2.md5
	
	# Fetch and extract
	echo "Getting mpfr-2.4.1"
	lazy_fetch $URL $PKG $MD5
	tar -xjvf $PKG
	
	# Move so we build with GCC
	mkdir -p gcc-4.4.1
	mv mpfr-2.4.1 gcc-4.4.1/mpfr
}

##############################################################################

function get_gcc
{
	URL=http://ftp.gnu.org/gnu/gcc/gcc-4.4.1/gcc-core-4.4.1.tar.bz2
	PKG=gcc-core-4.4.1.tar.bz2
	MD5=md5s/gcc-core-4.4.1.tar.bz2.md5
	
	# Fetch and extract
	echo "Getting GCC 4.4.1"
	lazy_fetch $URL $PKG $MD5
	tar -xjvf $PKG
	
	# Build
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
fi

# We'll put prereq libraries in here
mkdir -p $PREFIX

# Now fetch, build, and install all of the repreqs.
get_scons
get_bochs
get_binutils
get_gmp
get_mpfr
get_gcc

echo "Done. Prereqs installed in '$PREFIX'"
