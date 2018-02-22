#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
    git clone https://github.com/openssl/openssl.git
    cd openssl/
    git checkout 7a908204ed3afe1379151c6d090148edb2fcc87e
    echo "oissdnfvd"
}

_build() {
    cd openssl/
    set -o pipefail
    if [[ $compiler == "kcc" ]]; then
        CC="kcc -std=gnu11 -no-pedantic -frecover-all-errors" CXX=k++ LD=kcc ./config no-asm no-threads no-hw no-zlib no-shared |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    else
        CC=$compiler ./config no-asm no-threads no-hw no-zlib no-shared |& tee kcc_build_0.txt ; results[0]="$?" ; process_kcc_config 0
    fi
    make |& tee kcc_build_1.txt ; results[1]="$?" ; process_kcc_config 1
    kcc -d -std=gnu11 -no-pedantic -frecover-all-errors -DDSO_DLFCN -DHAVE_DLFCN_H -DNDEBUG -DOPENSSL_NO_DYNAMIC_ENGINE -DOPENSSL_PIC -DOPENSSLDIR="/usr/local/ssl" -DENGINESDIR="/usr/local/lib/engines-1.1" -Wall -O3 -m64 -DL_ENDIAN -o apps/openssl apps/app_rand.o apps/apps.o apps/asn1pars.o apps/ca.o apps/ciphers.o apps/cms.o apps/crl.o apps/crl2p7.o apps/dgst.o apps/dhparam.o apps/dsa.o apps/dsaparam.o apps/ec.o apps/ecparam.o apps/enc.o apps/engine.o apps/errstr.o apps/gendsa.o apps/genpkey.o apps/genrsa.o apps/nseq.o apps/ocsp.o apps/openssl.o apps/opt.o apps/passwd.o apps/pkcs12.o apps/pkcs7.o apps/pkcs8.o apps/pkey.o apps/pkeyparam.o apps/pkeyutl.o apps/prime.o apps/rand.o apps/rehash.o apps/req.o apps/rsa.o apps/rsautl.o apps/s_cb.o apps/s_client.o apps/s_server.o apps/s_socket.o apps/s_time.o apps/sess_id.o apps/smime.o apps/speed.o apps/spkac.o apps/srp.o apps/storeutl.o apps/ts.o apps/verify.o apps/version.o apps/x509.o -L. -lssl -L. -lcrypto -ldl |& tee kcc_build_2.txt ; names[2]="Special kcc -d call" ; results[2]="$?" ; process_kcc_config 2
}

_test() {
    cd openssl/
    names[0]="ecdsatest"
    ./test/ecdsatest |& tee "kcc_out_0.txt" ; results[0]="$?"
}


init
