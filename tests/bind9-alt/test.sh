#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	# dnstest
	sudo apt -y install erlang
	
	# bind9
    	sudo apt -y install openssl libssl-dev
}

_download() {
	bind9dl=$(pwd)
	git clone https://source.isc.org/git/bind9.git
	cd bind9/
	git checkout 63270d33f1103f6193aebd6c205b78064b4cdfe5

	cd ${bind9dl}
	git clone https://github.com/dnsimple/dnstest.git
	cd dnstest/
	git checkout 432614579fd5b059fa05d9e457e296ed84b7cc34
}

_build() {
	ulimit -s 16777216
	bind9dir=$(pwd)
	cd $bind9dir/dnstest/
	make
	
	cd $bind9dir/bind9/
	names[0]="outer configure step"
	# This configuration is setup specifically to work with rvpc
	./configure --prefix=$HOME/bind9 --host=x86_64-linux-gnu --build=x86_64-pc-linux-gnu --with-randomdev=/dev/random --with-ecdsa=yes --with-gost=yes --with-eddsa=no --with-atf=$HOME/rv/bind9/unit/atf BUILD_CC=gcc CC=$compiler CXX=$compiler++ |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	names[1]="found unit/atf-src/" ; [ -d unit/atf-src/ ] ; results[1]="$?" ; postup 1
	cd unit/atf-src/
	names[2]="inner configure step"
	./configure --prefix=$HOME/rv/bind9/unit/atf --enable-tools --disable-shared |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
	names[3]="inner make" ; make -j`nproc` |& tee rv_build_3.txt ; results[3]="$?" ; postup 3
	names[4]="inner make install" ; make -j`nproc` install |& tee rv_build_4.txt ; results[4]="$?" ; postup 4
	cd $bind9dir/bind9/
	names[5]="outer make" ; make -j`nproc` |& tee rv_build_5.txt ; results[5]="$?" ; postup 5
}

_test() {
    bind9testdir=$(pwd)
    cd bind9/
    #names[0]="make unit"
    #make -j`nproc` unit |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0


    cd bin/named/
    f="custom_folder"
    mkdir ${f}
    cd ${f}
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
    sudo ./named -c ./${f}/named.conf -d 10 -g -L ./out.log &
    for i in `seq 2 31`; do
        dig @localhost sun.world.cosmos > ${i}.log &
    done
    echo "did loop ======================================================================================="
    for i in `seq 2 31`; do
        wait %${i}
        echo "<< ${i} >>"
        cat ${i}.log
        echo ">> ${i} <<"
        rm ${i}.log
    done
    echo "dns test ======================================================================================="
    cd ${bind9testdir}/dnstest/
    sed -i -e "s/port, 8053/port, 53/g" dnstest.config
    bash run.sh > dnstest.log &
    sleep 10
    kill %2
    cat dnstest.log
    rm dnstest.log
    echo "server out======================================================================================"
    cat ${bind9testdir}/bind9/bin/named/out.log
    echo "finished========================================================================================"
}

init
