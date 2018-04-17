#!/bin/bash
set -a
sortfiles() {
	tt=$1
        name=$(basename ${tt})
	gcc -o ${tt}.out ${tt} &> /dev/null ; gccwin=$?
	rm -f ${tt}.out
	clang -o ${tt}.out ${tt} &> /dev/null ; clangwin=$?
	rm -f ${tt}.out
	if [ ! "${gccwin}" == "0" ] || [ ! "${clangwin}" == "0" ] ; then
		mv ${tt} smallcprograms/invalid
		echo "- invalid ${name}"
	else
		echo "+   valid ${name}"
	fi
}
doit() {
	tt=$1
	name=$(basename ${tt})
	log=${tt}.log
        #echo "tt is ${tt}"
        printf "\n===[${name}]=========================\n\n" > ${log}
        echo ${tt} >> ${log}
        cat ${tt} >> ${log}
        echo -n "${name}...     "
        while read cc; do
                #echo "cc is ${cc}"
                printf "\n---[compile, ${cc}, ${name}]--------------------------------\n" >> ${log}
                echo -en "\r[compiling, ${cc}, ${name}]...     "
                ${cc} -o ${tt}.out ${tt} &>> ${log}
		if [ ! -e ${tt}.out ] ; then continue ; fi
                printf "\n* *[runtime, ${cc}, ${name}] * * * * * * * * * * * * * * * *\n" >> ${log}
                echo -en "\r[  running, ${cc}, ${name}]...     "
                ${tt}.out &>> ${log}
		rm ${tt}.out
        done <smallcprograms/compilers.ini
        echo -e "\r${name} complete."
}
set +a
cat "gcc
clang
kcc
rvpc
" > smallcprograms/compilers.ini
mkdir -p smallcprograms/invalid
if [ ! "$1" == "" ] ; then
	find ${1} -name "*.c" -exec cp {} smallcprograms/ \;
fi
find smallcprograms -name "*.c" | parallel --eta --timeout 500 "sortfiles {}"
find smallcprograms -name "*.c" | parallel --eta --timeout 500 "doit {}"
log="smallcprograms/out.all"
rm ${log} ; touch ${log}
find smallcprograms -name "*.log" | xargs cat >> ${log}
echo "Log: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
cat ${log}
