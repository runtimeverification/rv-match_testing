#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    git clone https://github.com/vergecurrency/VERGE
    cd VERGE/
    git checkout 1c418be3bf0fe751799052df768eb5784e3b400b
}

_build() {
    cd VERGE/
    bash autogen.sh && ./configure CC=$compiler LD=$compiler ; configure_success="$?"
    make ; make_success="$?"
}

_test() {
    return
}

_extract_test() {
    echo "Inside the _extract_test() function now."
}

init
