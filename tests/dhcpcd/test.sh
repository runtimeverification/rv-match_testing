#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_download() {
	git clone https://github.com/rsmarples/dhcpcd.git
	cd dhcpcd/
	git checkout c80bb16819614b1c7b38dbefa8b4efc81755f138 # Tag v7.0.3
	#git checkout 7a3669251dca114f259e6c140a315e4e85fbd10f
}

_build() {
	cd dhcpcd/
	dhcfolder=$(pwd)
	if [[ $compiler == "kcc" ]]; then
		kcc -profile x86_64-linux-gcc-glibc
		./configure CC=kcc CFLAGS="-D__packed='__attribute__((packed))' -frecover-all-errors -fissue-report=$json_out" LD=kcc |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	else
		./configure CC=$compiler |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
	fi
	make -j`nproc` |& tee rv_build_1.txt
	[ -f src/dhcpcd ] ; results[1]="$?" ; postup 1
	
	# Patch 1, try default
	cd ${dhcfolder}/dhcpcd/
	

	# Patch 2, try all types
	cd ${dhcfolder}/dhcpcd/
	mkdir test-export/
	cd tests/
	sed -i -e "s/CPPFLAGS+=\t-DWARN_SELECT/#CPPFLAGS+=\t-DWARN_SELECT/g" eloop-bench/Makefile

	sed -i -e "s/#CPPFLAGS+=\t-DHAVE_KQUEUE/CPPFLAGS+=\t-DHAVE_KQUEUE/g" eloop-bench/Makefile
	make clean
	names[2]="kqueue" ; CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_2.txt ; results[2]="$?" ; postup 2
	mv eloop-bench/eloop-bench ${dhcfolder}/test-export/eloop-bench-kqueue
	sed -i -e "s/CPPFLAGS+=\t-DHAVE_KQUEUE/#CPPFLAGS+=\t-DHAVE_KQUEUE/g" eloop-bench/Makefile

	sed -i -e "s/#CPPFLAGS+=\t-DHAVE_POLLTS/CPPFLAGS+=\t-DHAVE_POLLTS/g" eloop-bench/Makefile
	make clean
	names[3]="pollts" ; CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_3.txt ; results[3]="$?" ; postup 3
	mv eloop-bench/eloop-bench ${dhcfolder}/test-export/eloop-bench-pollts
	sed -i -e "s/CPPFLAGS+=\t-DHAVE_POLLTS/#CPPFLAGS+=\t-DHAVE_POLLTS/g" eloop-bench/Makefile

	sed -i -e "s/#CPPFLAGS+=\t-DHAVE_PSELECT/CPPFLAGS+=\t-DHAVE_PSELECT/g" eloop-bench/Makefile
	make clean
	names[4]="pselect" ; CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_4.txt ; results[4]="$?" ; postup 4
	mv eloop-bench/eloop-bench ${dhcfolder}/test-export/eloop-bench-pselect
	sed -i -e "s/CPPFLAGS+=\t-DHAVE_PSELECT/#CPPFLAGS+=\t-DHAVE_PSELECT/g" eloop-bench/Makefile

	sed -i -e "s/#CPPFLAGS+=\t-DHAVE_EPOLL/CPPFLAGS+=\t-DHAVE_EPOLL/g" eloop-bench/Makefile
	make clean
	names[5]="epoll" ; CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_5.txt ; results[5]="$?" ; postup 5
	mv eloop-bench/eloop-bench ${dhcfolder}/test-export/eloop-bench-epoll
	sed -i -e "s/CPPFLAGS+=\t-DHAVE_EPOLL/#CPPFLAGS+=\t-DHAVE_EPOLL/g" eloop-bench/Makefile

	sed -i -e "s/#CPPFLAGS+=\t-DHAVE_PPOLL/CPPFLAGS+=\t-DHAVE_PPOLL/g" eloop-bench/Makefile
	make clean
	names[6]="ppoll" ; CC=$compiler LD=$compiler make -j`nproc` |& tee rv_build_6.txt ; results[6]="$?" ; postup 6
	mv eloop-bench/eloop-bench ${dhcfolder}/test-export/eloop-bench-ppoll
	sed -i -e "s/CPPFLAGS+=\t-DHAVE_PPOLL/#CPPFLAGS+=\t-DHAVE_PPOLL/g" eloop-bench/Makefile
}

_test() {
	begindhcpcdtestdir=$(pwd)
	cd $begindhcpcdtestdir/dhcpcd/tests/crypt/
	names[0]="crypt" ; ./run-test |& tee rv_out_0.txt ; results[0]="$?" ; process_config 0
    
	cd $begindhcpcdtestdir/dhcpcd/test-export/
	names[1]="eloop-bench-kqueue" ; ./eloop-bench-kqueue -a 2 -r 50 |& tee rv_out_1.txt ; results[1]="$?" ; process_config 1
	names[2]="eloop-bench-pollts" ; ./eloop-bench-pollts -a 2 -r 50 |& tee rv_out_2.txt ; results[2]="$?" ; process_config 2
	names[3]="eloop-bench-pselect" ; ./eloop-bench-pselect -a 2 -r 50 |& tee rv_out_3.txt ; results[3]="$?" ; process_config 3
	names[4]="eloop-bench-epoll" ; ./eloop-bench-epoll -a 2 -r 50 |& tee rv_out_4.txt ; results[4]="$?" ; process_config 4
	names[5]="eloop-bench-ppoll" ; ./eloop-bench-ppoll -a 2 -r 50 |& tee rv_out_5.txt ; results[5]="$?" ; process_config 5
}

init
