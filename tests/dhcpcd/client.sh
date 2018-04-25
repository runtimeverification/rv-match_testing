#!/bin/bash
# https://github.com/rsmarples/dhcpcd.git
# git checkout c80bb16819614b1c7b38dbefa8b4efc81755f138 # Tag v7.0.3
kcc -profile x86_64-linux-gcc-glibc
./configure CC=kcc CFLAGS="-D__packed='__attribute__((packed))' -frecover-all-errors -fissue-report=$(pwd)" LD=kcc
make -j`nproc`
cd tests/
CC=kcc LD=kcc make -j`nproc`
cd crypt/
./run-test
cd ../eloop-bench/
./eloop-bench
