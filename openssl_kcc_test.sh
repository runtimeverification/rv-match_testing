rm -rf openssl_kcc_test
mkdir openssl_kcc_test
cd openssl_kcc_test
STRTDIR=$(pwd)
if [[ ! -d openssl ]]; then
   git clone https://github.com/openssl/openssl.git
fi
cd openssl
git checkout 7a908204ed3afe1379151c6d090148edb2fcc87e
CC=kcc LD=kcc ./config |& tee kcc_config_out.txt
make |& tee kcc_make_out.txt
kcc -d -I. -Icrypto/include -Iinclude -DDSO_DLFCN -DHAVE_DLFCN_H -DNDEBUG -DOPENSSL_THREADS -DOPENSSL_NO_STATIC_ENGINE -DOPENSSL_PIC -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DGHASH_ASM -DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DOPENSSLDIR="/usr/local/ssl" -DENGINESDIR="/usr/local/lib/engines-1.1" -Wall -O3 -pthread -m64 -DL_ENDIAN -fPIC -DOPENSSL_USE_NODELETE -c -o crypto/bio/bss_bio.o crypto/bio/bss_bio.c |& tee kcc_out.txt
mkdir kcc_compile_out
mv kcc_config_out.txt kcc_compile_out/
mv kcc_make_out.txt kcc_compile_out/
mv kcc_out.txt kcc_compile_out/
mv config kcc_compile_out/
cd $STRTDIR
mv openssl/kcc_compile_out .
tar -czvf kcc_compile_out.tar.gz kcc_compile_out
