#!/bin/bash
. prepare.sh $(basename $(dirname $BASH_SOURCE))

if [[ ! -d openssl ]]; then
   git clone https://github.com/openssl/openssl.git
fi
cd openssl
git checkout 7a908204ed3afe1379151c6d090148edb2fcc87e
CC=kcc LD=kcc ./config |& tee kcc_config_out.txt
make |& tee kcc_make_out.txt
kcc -d -I. -Icrypto/include -Iinclude -DDSO_DLFCN -DHAVE_DLFCN_H -DNDEBUG -DOPENSSL_THREADS -DOPENSSL_NO_STATIC_ENGINE -DOPENSSL_PIC -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DGHASH_ASM -DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DOPENSSLDIR="/usr/local/ssl" -DENGINESDIR="/usr/local/lib/engines-1.1" -Wall -O3 -pthread -m64 -DL_ENDIAN -fPIC -DOPENSSL_USE_NODELETE -c -o crypto/bio/bss_bio.o crypto/bio/bss_bio.c |& tee kcc_out.txt
mv_kcc_out
cd $log_dir
k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
cd $build_dir
#tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
