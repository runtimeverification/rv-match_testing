#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/firehol/netdata.git
    cd netdata/
    git checkout 2bbde1ba150b0d6fb66cd01d94b26da0181fd45e
}

_build() {
    cd netdata/
    autoscan
    aclocal
    autoheader
    autoreconf
    automake --add-missing
    autoreconf
    set -o pipefail
    ./configure CC=kcc LD=kcc |& tee kcc_configure_out.txt ; configure_success="$?"
    make |& tee kcc_make_out.txt ; make_success="$?"
    cd ./src/
    kcc -d -g -pthread -o apps.plugin apps_plugin.o avl.o clocks.o common.o log.o procfile.o web_buffer.o -lm |& tee kcc_out.txt
}

_extract() {
    cd netdata/
    
    # Call extract kcc_ here
    mv kcc_out.txt $log_dir
    
    # Call process kcc_config here
    mv src/kcc_config $log_dir
    
    cd $log_dir
    k-bin-to-text kcc_config kcc_config.txt && grep -o "<k>.\{500\}" kcc_config.txt &> kcc_config_k_summary.txt
    echo "==== kcc configure status reported:"$configure_success
    echo $configure_success > kcc_configure_success.ini
    echo "==== kcc make status reported:"$make_success
    echo $make_success > kcc_make_success.ini
    tar -czvf kcc_compile_out.tar.gz --exclude "kcc_config.txt" kcc_compile_out
}

init
