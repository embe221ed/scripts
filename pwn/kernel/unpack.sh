#!/bin/sh

mkdir unpacked
cd unpacked
cpio -idv < ../rootfs.cpio 
