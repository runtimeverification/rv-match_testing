#!/bin/bash
# git repository: https://github.com/curl/curl.git
# git checkout  : 00cda0f9b31e45512776670201f9ec2eec095338
apt_install() {
	sudo apt -yqq install $@
}
build_step() {
	echo "build-[$1]" ; shift ; $@
}
test_step() {
	echo "test--[$1]" ; shift ; $@
}
apt_install libssl-dev
build_step "configure" ./configure --enable-curldebug
build_step "make" make -j`nproc`
build_step "make tests" make -j`nproc` tests
test_step "runtests.pl" ./runtests.pl 5
