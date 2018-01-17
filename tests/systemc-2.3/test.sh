#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

#git clone https://github.com/systemc/systemc-2.3.git
#cd systemc-2.3/
#git checkout 686336b03ea17374024df0ae8272d7e22ba2692f
echo "systemc-2.3 script is not implemented."
