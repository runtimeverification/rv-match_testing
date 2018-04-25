#!/bin/bash
# https://github.com/firehol/netdata.git
# 2bbde1ba150b0d6fb66cd01d94b26da0181fd45e
sudo apt -y install zlib1g-dev uuid-dev
autoscan
aclocal
autoheader
autoreconf
automake --add-missing
autoreconf
./configure CC=kcc CFLAGS="-std=gnu11 -frecover-all-errors -no-pedantic" LD=kcc
make -j`nproc`
