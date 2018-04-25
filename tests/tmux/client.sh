#!/bin/bash
# https://github.com/tmux/tmux.git
# cf782c4f546fb11f3157de7aecff85845b0dbed9
sudo apt -y install libevent-dev
bash autogen.sh
./configure CC=kcc CFLAGS="-no-pedantic" LD=kcc
make -j`nproc`
