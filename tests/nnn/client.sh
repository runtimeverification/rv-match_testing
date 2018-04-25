#!/bin/bash
# https://github.com/jarun/nnn.git
# 7be0726164442a83f47e5a9a0cdf2db343832d23
sudo apt -y install libncursesw5-dev libreadline6-dev
CC=kcc LD=kcc make -j`nproc`
CC=kcc LD=kcc make -j`nproc` install
