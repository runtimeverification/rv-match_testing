#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
	# bazel dependencies:
	#  - Instructions: https://docs.bazel.build/versions/master/install-ubuntu.html
	#  - JDK8 (which is likely already installed)
	echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | sudo tee /etc/apt/sources.list.d/bazel.list
	curl https://bazel.build/bazel-release.pub.gpg | sudo apt-key add -
	sudo apt-get update && sudo apt-get install bazel
	sudo apt-get upgrade bazel

	# direct tensorflow dependencies:
	sudo apt-get install python-pip python-dev python-virtualenv
	
	# for testing:
	pip install pandas
}

_download() {
	tensorflowdownloaddir=$(pwd)
	git clone https://github.com/tensorflow/tensorflow.git
	cd tensorflow/
	git checkout 024aecf414941e11eb643e29ceed3e1c47a115ad # Tag v1.7.0

	cd ${tensorflowdownloaddir}
	git clone https://github.com/tensorflow/models
	cd models/
	git checkout e191c66f2246c11e93303349c36cb5ded48ddbb6 # Tag v1.8.0
}

_build() {
	cd tensorflow/
	names[0]="configure" ; yes | ./configure |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	names[1]="bazel build" ; bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
	cd models/samples/core/get_started/
	names[0]="premade estimator" ; python premade_estimator.py |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
}

init
