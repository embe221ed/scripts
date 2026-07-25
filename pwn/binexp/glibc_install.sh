#!/bin/sh
# Claas Heuer, August 2015
# 
# urls:
# http://stackoverflow.com/questions/847179/multiple-glibc-libraries-on-a-single-host
# http://www.gnu.org/software/libc/download.html

cd /opt/
mkdir glibc_update
cd glibc_update

libc_version=2.27

# get the version you want:
wget http://ftp.gnu.org/gnu/glibc/glibc-${libc_version}.tar.gz

tar -xf glibc-${libc_version}.tar.gz

# configure and set the installation path
cd glibc-${libc_version}
mkdir build
cd build
../configure --prefix=/opt/glibc${libc_version} --disable-werror

# compile
make -j6

sudo make install


##############################################
### Run some software that need that glibc ###
##############################################


# LD_PRELOAD="/opt/glibc${libc_version}/lib/libc.so.6 /opt/glibc${libc_version}/lib/libpthread.so.0 /opt/glibc${libc_version}/lib/ld-linux-x86-64.so.2" ./my_prog
























