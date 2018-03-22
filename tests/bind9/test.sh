#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    sudo apt -y install openssl
    sudo apt -y install libssl-dev
}

_download() {
    git clone https://source.isc.org/git/bind9.git
    cd bind9/
    git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5
}

_build() {
    cd bind9/
    names[0]="autoreconf"
    autoreconf |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    set -o pipefail

    names[1]="configure success"
    if [[ "$compiler" == "kcc" ]] ; then
        ./configure --with-atf CC=$compiler CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors" LD=kcc --disable-threads --disable-atomic --disable-shared |& tee rv_build_1.txt ; results[1]="$?"
    else
        if [[ "$compiler" == "rvpc" ]] ; then
            ./configure --with-atf CC=$compiler |& tee rv_build_1.txt ; results[1]="$?"
        else
            ./configure --with-atf CC=$compiler --disable-threads --disable-atomic --disable-shared |& tee rv_build_1.txt ; results[1]="$?"
        fi
    fi
    postup 1

    names[2]="compile gen with gcc"
    gcc -Ilib/isc/include -o lib/dns/gen lib/dns/gen.c |& tee -a rv_build_2.txt ; results[2]="$?" ; postup 2

    #names[3]="set ulimit"
    #ulimit -s 16777216 |& tee -a rv_build_3.txt ; results[3]="$?" ; postup 3

    names[3]="make success"
    ulimit -s 16777216
    make |& tee rv_build_3.txt ; results[3]="$?" ; postup 3

}

_test() {
    echo "rvpredict var inside: [$rvpredict]"
    if [ -z ${rvpredict+x} ]; then names[0]="problem with prepare.sh"; results[0]="1"; echo "'rvpredict' variable wasn't set." ; return; fi
    cd bind9/
    names[0]="make unit"
    make unit |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0

    return

    cd bin/named/
    f="custom_folder"
    mkdir $f
    cd $f
    # 127.0.0.zone, localhost.zone, named.conf, world.zone, root.hint

    echo '@                               1D IN SOA   localhost. root.localhost. (
                                    42    ; serial (yyyymmdd##)
                                    3H    ; refresh
                                    15M   ; retry
                                    1W    ; expiry
                                    1D )  ; minimum ttl

                                1D  IN  NS      localhost.

1.0.0.127.in-addr.arpa.         1D  IN  PTR     localhost.' > 127.0.0.zone

    echo '$TTL      86400
$ORIGIN localhost.
@                       1D IN SOA       @ root (
                                        42              ; serial (d. adams)
                                        3H              ; refresh
                                        15M             ; retry
                                        1W              ; expiry
                                        1D )            ; minimum

                        1D IN NS        @
                        1D IN A         127.0.0.1' > localhost.zone

    echo 'options { 
        directory replacemeplease;
        forwarders { 10.0.0.1; };
        notify no;
};

zone "localhost" in {
       type master;
       file "localhost.zone";
};

zone "0.0.127.in-addr.arpa" in {
        type master;
        file "127.0.0.zone";
};

zone "world.cosmos" in {
        type master;
        file "world.zone";
};

zone "." in {
        type hint;
        file "root.hint";
};' > named.conf

    pwdesc=$(echo "\"$PWD\"" | sed 's_/_\\/_g')
    sed -i -e "s/replacemeplease/$pwdesc/g" named.conf
    echo "named.conf : --------------------"
    cat named.conf
    echo "---------------------------------"

    echo '$TTL 2D
world.cosmos. IN SOA      gateway  root.world.cosmos. (
            2003072441  ; serial
            1D          ; refresh
            2H          ; retry
            1W          ; expiry
            2D )        ; minimum

            IN NS       gateway
            IN MX       10 sun

gateway     IN A        192.168.0.1
            IN A        192.168.1.1
sun         IN A        192.168.0.2
moon        IN A        192.168.0.3
earth       IN A        192.168.1.2
mars        IN A        192.168.1.3
www         IN CNAME    moon' > world.zone    

    touch root.hint    

    cd ..
    sudo ./named -c ./$f/named.conf -d 100 -g -L ./out.log &
    for i in `seq 30`; do
        dig @localhost sun.world.cosmos &
    done
    echo "did loop ======================================================================================="
    for i in `seq 2 31`; do
        wait %${i}
    done
    echo "finished========================================================================================" 
}

init
