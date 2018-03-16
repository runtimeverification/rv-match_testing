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
    ulimit -s 16777216
    cd bind9/
    bind9dir=$(pwd)
    names[0]="outer configure step"
    # This configuration is setup specifically to work with rvpc
    ./configure --prefix=$HOME/bind9 --host=x86_64-linux-gnu --build=x86_64-pc-linux-gnu --with-randomdev=/dev/random --with-ecdsa=yes --with-gost=yes --with-eddsa=no --with-atf=$HOME/rv/bind9/unit/atf BUILD_CC=gcc CC=$compiler CXX=$compiler++ |& tee kcc_make_0.txt ; results[0]="$?" ; process_kcc_config 0
    names[1]="found unit/atf-src/" ; [ -d unit/atf-src/ ] ; results[1]="$?" ; process_kcc_config 1
    cd unit/atf-src/
    names[2]="inner configure step"
    ./configure --prefix=$HOME/rv/bind9/unit/atf --enable-tools --disable-shared |& tee kcc_make_2.txt ; results[2]="$?" ; process_kcc_config 2
    names[3]="inner make" ; make |& tee kcc_make_3.txt ; results[3]="$?" ; process_kcc_config 3
    names[4]="inner make install" ; make install |& tee kcc_make_4.txt ; results[4]="$?" ; process_kcc_config 4
    cd $bind9dir
    names[5]="outer make" ; make |& tee kcc_make_5.txt ; results[5]="$?" ; process_kcc_config 5
}

_test() {
    cd bind9/
    names[0]="make unit"
    make unit |& tee kcc_out_0.txt ; results[0]="$?" ; process_config 0


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
