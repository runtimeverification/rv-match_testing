#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	:
}

_download() {
	mkdir helloworld/ ; cd helloworld/
	echo "
// trivial C++ program
#include <iostream>

int main()
{
  std::cout << \"Hello World!\";
}
" > helloworld.cpp
}

_build() {
	cd helloworld/
	names[0]="compile" ; $compilerpp helloworld.cpp |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
}

_test() {
	cd helloworld/
	names[0]="basic run"
	./a.out |& tee "rv_out_0.txt" ; results[0]="$?"
}

init
