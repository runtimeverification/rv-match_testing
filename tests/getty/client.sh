#!/bin/bash
# https://github.com/StarchLinux/getty.git
# a6c24ec43804588a3c35c9ed3325ed3086ddd056
sed -i "/strip/d" Makefile
make -j`nproc` CC=kcc LD=kcc
