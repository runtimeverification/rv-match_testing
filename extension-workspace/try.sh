#!/bin/bash
rm -rf .tmp-kcc-*
rm -f a.out ; gcc testing.c ; echo "gcc build: $?"
./a.out ; echo "gcc   run: $?"
rm -f a.out ; rm -f kcc_config ; rm -f kcc_config.txt ; kcc -d testing.c ; echo "kcc build: $?"
./a.out ; echo "kcc   run: $?"
k-bin-to-text kcc_config kcc_config.txt
grep -o "<k>.\{0,500\}" kcc_config.txt
grep -o "<curr-program-loc>.\{500\}" kcc_config.txt
