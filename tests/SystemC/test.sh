#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

#git clone https://github.com/ArchC/SystemC.git
#cd SystemC
#git checkout 778e7c6b45564494a98e6c1526f492b271c5696e
echo "SystemC script not implemented."
