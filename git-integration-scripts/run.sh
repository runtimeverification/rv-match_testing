#!/bin/bash
set -e
git clone "$1"
base=$(basename $1)
folder=${base%.git}
[ -d "$folder" ]
cd "$folder"
git checkout "$2"
if [ -e rv.sh ] ; then use="" ; else use="../" ; fi
cp "${use}rv.sh" ./rv-testing.sh
source rv-testing.sh
apt_install() {
	echo "mother install"
        sudo apt -yqq install $@
}
build_step() {
        execute_step "mother build-" $@
}
test_step() {
        execute_step "mother test--" $@
}
execute_step() {
        print_string="$1[$2]"
        echo "=== mother running $print_string" ; shift 2 ; $@
        if [ "$?" == "0" ] ; then
                echo "=== mother PASS $print_string"
        else
                echo "=== mother FAIL $print_string"
                exit 1
        fi
}
configuration
