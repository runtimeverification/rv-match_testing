#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	sudo apt -y install webkit2gtk-4.0
}

_download() {
	git clone https://github.com/yue/yue.git
	cd yue/
	git checkout b62a6fbe852f219f41fa3d6d0d2b866fadb5542a # Tag v0.4.0
}

_build() {
	# http://libyue.com/docs/v0.4.0/cpp/guides/getting_started.html
	cd yue/
	mkdir build/
	cd build/
	names[0]="cmake" ; cmake -D CMAKE_BUILD_TYPE=Release .. |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	names[1]="yue" ; make |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
	cd yue/build/
	names[0]="sample app" ; ./sample_app |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
