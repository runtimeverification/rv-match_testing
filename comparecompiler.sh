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
	wid1=120 ; wid2=59 ; wid3=39 ; wid4=29
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
	$1 -o ${tt}.compiled-$1 ${tt} &>> ${tt}.compile-log-$1 ; retval=$?
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
				echo "$1 runtime difference."
				echo "${tt} returned [$2] when compiled with gcc & clang."
				echo "Yet it returned [$run_result] when compiled with $1."
			fi
		else
			compilelog=0
			echo "Fatal Error: [${1}, missing output]"
			echo "${tt} compiled successfully yet ${tt}.compiled-$1 was not produced."
		fi
	else
		compilelog=0
		if [ -e ${tt}.compiled-$1 ] ; then
			echo "Fatal Error: [${1}, unexpected output]"
                        echo "${tt} compile failure yet ${tt}.compiled-$1 was still produced."
                else
			echo "${1} compile time deficiency."
			echo "${tt} failed to compile. Yet could with gcc & clang."
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
	tt="./${name}"
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
			echo "${q} compile $q"
			printcol
			echo "${q}---------$q"
		fi
		a=${tt}.run-log-gcc
                b=${tt}.run-log-clang
                c=${tt}.run-log-kcc
                d=${tt}.run-log-rvpc
		if [ "$runtimelog" == "0" ] ; then
			echo "${q}   run   $q"
			printcol
			echo "${q}---------$q"
		fi
	fi
	delete gcc
	delete clang
	delete kcc
	delete rvpc
	rm -f config
	rm -f kcc_config
}
p="====================================================="
q="-----------------------------------------------------"
if [ ! "$1" == "" ] ; then
	find ${1} -name "*.c" | parallel --eta --timeout 500 "doit {}"
else
	echo "usage: bash comparecompilers.sh ./path/to/dir/with/c/files/in/subfolders/"
fi
