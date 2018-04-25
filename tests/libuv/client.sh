#!/bin/bash
# https://github.com/libuv/libuv.git
# 719dfecf95b0c74af6494f05049e56d5771ebfae
bash autogen.sh
./configure CC=kcc LD=kcc
make -j`nproc`
