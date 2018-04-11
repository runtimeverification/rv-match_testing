#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	# Actually from './BuildTools/InstallSwiftDependencies.sh'
	sudo apt-get -y install pkg-config libssl-dev qt5-default libqt5x11extras5-dev libqt5webkit5-dev qtmultimedia5-dev qttools5-dev-tools
}

_download() {
	git clone https://github.com/swift/swift.git
	cd swift/
	git checkout 14ddf8b470f5a3420b5f2c96daea33c2513cac6e # Tag v3.0
}

_build() {
	# https://github.com/swift/swift/blob/swift-3.x/Documentation/BuildingOnUnix.txt
	cd swift/
	names[0]="scons" ; ./scons |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
}

_test() {
	cd swift/
	names[0]="scons unittest" ; ./scons test=unit |& tee rv_build_0.txt ; results[0]="$?" ; process_config 0
}

init
