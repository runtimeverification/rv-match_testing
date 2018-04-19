#!/bin/bash
set -a
printcol() {
	len=2
	if [ "`wc -l $d | cut -f1 -d" "`" == "$len" ] ; then
		d=""
	fi
	if [ "`wc -l $c | cut -f1 -d" "`" == "$len" ] ; then
		c=$d ; d=""
	fi
	if [ "`wc -l $b | cut -f1 -d" "`" == "$len" ] ; then
		b=$c ; c=$d ; d=""
	fi
	if [ "`wc -l $a | cut -f1 -d" "`" == "$len" ] ; then
		a=$b ; b=$c ; c=$d ; d=""
		if [ "$a" == "" ] ; then
			return
		fi
	fi
	page=120
	wid1=${page} ; wid2=$(( ${page} / 2 - 1 )) ; wid3=$(( ${page} / 3 - 1 )) ; wid4=$(( ${page} / 4 - 1 ))
	s="|"
	if [ "$d" == "" ] ; then
		if [ "$c" == "" ] ; then
			if [ "$b" == "" ] ; then
				pr -S"$s" -m -t --width=$page <(fmt -w $wid1 $a)
        		else
				pr -S"$s" -m -t --width=$page <(fmt -w $wid2 $a) <(fmt -w $wid2 $b)
        		fi
        	else
			pr -S"$s" -m -t --width=$page <(fmt -w $wid3 $a) <(fmt -w $wid3 $b) <(fmt -w $wid3 $c)
        	fi
	else
		pr -S"$s" -m -t --width=$page <(fmt -w $wid4 $a) <(fmt -w $wid4 $b) <(fmt -w $wid4 $c) <(fmt -w $wid4 $d)
	fi
}
compile() {
	echo "." > ${tt}.compile-log-$1
	if [ "$1" == "kcc" ] ; then
		flag="-frecover-all-errors"
	else
		flag=""
	fi
	$1 ${flag} -o ${tt}.compiled-$1 ${tt} &>> ${tt}.compile-log-$1 ; retval=$?
	sed -i "1s/.*/[$1, $retval]\n/" ${tt}.compile-log-$1
	return $retval
}
run() {
	echo "." > ${tt}.run-log-$1
	${tt}.compiled-$1 &>> ${tt}.run-log-$1 ; retval=$?
	sed -i "1s/.*/[$1, $retval]\n/" ${tt}.run-log-$1
	return $retval
}
report() {
	#echo "report() 1[$1]"
	compile $1 ; compile_success="$?"
	if [ "$compile_success" == "0" ] ; then
		if [ -e ${tt}.compiled-$1 ] ; then
			run $1 ; run_result="$?"
			if [ "$run_result" == "$2" ] ; then
				echo "$1 compiled run of ${tt} matches with gcc & clang compiled runs."
			else
				runtimelog=0
				echo "$1 runtime difference." >> ${tt}.runtime-report
				echo "${tt} returned [$2] when compiled with gcc & clang." >> ${tt}.runtime-report
				echo "Yet it returned [$run_result] when compiled with $1." >> ${tt}.runtime-report
			fi
		else
			compilelog=0
			echo "Fatal Error: [${1}, missing output]" >> ${tt}.compile-report
			echo "${tt} compiled successfully yet ${tt}.compiled-$1 was not produced." >> ${tt}.compile-report
		fi
	else
		compilelog=0
		if [ -e ${tt}.compiled-$1 ] ; then
			echo "Fatal Error: [${1}, unexpected output]" >> ${tt}.compile-report
                        echo "${tt} compile failure yet ${tt}.compiled-$1 was still produced." >> ${tt}.compile-report
                else
			echo "${1} compile time deficiency." >> ${tt}.compile-report
			echo "${tt} failed to compile. Yet could with gcc & clang." >> ${tt}.compile-report
                fi
	fi
}
delete() {
	rm -f ${tt}
	rm -f ${tt}.compiled-$1
	rm -f ${tt}.compile-log-$1
	rm -f ${tt}.run-log-$1
}
doit() {
	name=$(basename $1)
	tt="./pid$$-${name}"
	cp $1 ${tt}
	compilelog=1 ; runtimelog=1
        #printf "\n===[${name}]=========================\n"
	compile "gcc" ; gcc_compile_result="$?"
	if [ "$gcc_compile_result" == "0" ] ; then
		compile "clang" ; clang_compile_result="$?"
		if [ "$clang_compile_result" == "0" ] ; then
			run "gcc" ; gcc_run_result="$?"
			run "clang" ; clang_run_result="$?"
			if [ "$gcc_run_result" == "$clang_run_result" ] ; then
				rm -f ${tt}.compile-report
				rm -f ${tt}.runtime-report
				report "kcc" "$gcc_run_result"
				report "rvpc" "$gcc_run_result"
			fi
		else
			: #echo "compiled with gcc but not clang"
		fi
	else
		: #echo "failed to compile with gcc"
	fi
	if [ "$compilelog" == "0" ] || [ "$runtimelog" == "0" ] ; then
		printf "\n$p[$name]$p\n"
		cat ${tt}
		a=${tt}.compile-log-gcc
		b=${tt}.compile-log-clang
		c=${tt}.compile-log-kcc
		d=${tt}.compile-log-rvpc
		wid=39
		page=120
		if [ "$compilelog" == "0" ] ; then
			echo "${q}--------------compile--------------$q"
			cat ${tt}.compile-report
			echo "${q}-[compiler, compile time exit code]$q"
			printcol
			echo "${q}-----------------------------------$q"
		fi
		a=${tt}.run-log-gcc
                b=${tt}.run-log-clang
                c=${tt}.run-log-kcc
                d=${tt}.run-log-rvpc
		if [ "$runtimelog" == "0" ] ; then
			echo "${q}----------------run----------------$q"
			cat ${tt}.runtime-report
			echo "${q}---[compiler, runtime exit code]---$q"
			printcol
			echo "${q}-----------------------------------$q"
		fi
	fi
	rm -f ${tt}.compile-report
	rm -f ${tt}.runtime-report
	delete gcc
	delete clang
	delete kcc
	delete rvpc
	rm -f config
	rm -f kcc_config
}
p="====================================================="
q="-----------------------------------------------------"
which clang &> /dev/null ; have_clang="$?"
which gcc &> /dev/null ; have_gcc="$?"
which kcc &> /dev/null ; have_kcc="$?"
which rvpc &> /dev/null ; have_rvpc="$?"
which parallel &> /dev/null ; have_parallel="$?"
if [ ! "${have_clang}${have_gcc}${have_kcc}${have_rvpc}${have_parallel}" == "00000" ] ; then
	if [ ! "${have_clang}" ] ; then echo "Need clang. try sudo apt -y install clang" ; fi
	if [ ! "${have_gcc}" ] ; then echo "Need gcc. try sudo apt -y install gcc" ; fi
	if [ ! "${have_kcc}" ] ; then echo "Need kcc. Get rv-match from the runtimeverification website." ; fi
	if [ ! "${have_rvpc}" ] ; then echo "Need rvpc. Get rv-predict from the runtimeverification website." ; fi
	if [ ! "${have_parallel}" ] ; then echo "Need GNU parallel. try sudo apt -y install parallel." ; fi
	exit 1
fi
etaflag=""
if [ "$2" == "-eta" ] ; then
	etaflag="--eta"
fi
if [ ! "$1" == "" ] && [ -d "$1" ] ; then
	find ${1} -name "*.c" | parallel --no-notice ${etaflag} --timeout 500 "doit {}"
else
	echo "usage: bash comparecompilers.sh ./path/to/dir/with/c/files/in/subfolders/ [-eta]"
fi
