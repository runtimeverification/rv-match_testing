#!/bin/bash
# git repository: https://github.com/curl/curl.git
# git checkout  : 00cda0f9b31e45512776670201f9ec2eec095338
apt_install() {
	sudo apt -yqq install $@
}
build_step() {
	execute_step "build-" $@
}
test_step() {
	execute_step "test--" $@
}
execute_step() {
	print_string="$1[$2]"
	echo "=== running $print_string" ; shift 2 ; $@
	if [ "$?" == "0" ] ; then
		echo "=== PASS $print_string"
	else
		echo "=== FAIL $print_string"
		exit 1
	fi
}
configuration() {
	# Only edit this function
	# Runtime Verification will use its own definitions for the other functions.
	# They are available here to allow you to test this script locally.
	apt_install libssl-dev
	build_step autoreconf autoreconf -i
	build_step configure ./configure --enable-curldebug
	build_step make make -j`nproc`
	build_step make-tests make -j`nproc` tests
	cd tests/
	test_step "runtests.pl" ./runtests.pl 1
}
configuration
