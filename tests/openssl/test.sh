#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/openssl/openssl.git
    cd openssl/
    git checkout 7a908204ed3afe1379151c6d090148edb2fcc87e
}

_build() {
    cd openssl/
    set -o pipefail
    CC=$compiler LD=$compiler ./config |& tee kcc_config_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
    $compiler -d -I. -Icrypto/include -Iinclude -DDSO_DLFCN -DHAVE_DLFCN_H -DNDEBUG -DOPENSSL_THREADS -DOPENSSL_NO_STATIC_ENGINE -DOPENSSL_PIC -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DGHASH_ASM -DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DOPENSSLDIR="/usr/local/ssl" -DENGINESDIR="/usr/local/lib/engines-1.1" -Wall -O3 -pthread -m64 -DL_ENDIAN -fPIC -DOPENSSL_USE_NODELETE -c -o crypto/bio/bss_bio.o crypto/bio/bss_bio.c |& tee kcc_out.txt
}

_extract() {
    cd openssl/ && process_kcc_config
    cd openssl/ && cp kcc_* $log_dir
}

init
