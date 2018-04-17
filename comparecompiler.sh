#!/bin/bash
set -a
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
                printf "\n* *[runtime, ${cc}, ${name}] * * * * * * * * * * * * * * * *\n" >> ${log}
                echo -en "\r[  running, ${cc}, ${name}]...     "
                ${tt}.out &>> ${log}
		rm ${tt}.out
        done <smallcprograms/compilers.ini
        echo -e "\r${name} complete."
}
set +a
find smallcprograms -name "*.c" | parallel --eta --timeout 500 "doit {}"
log="smallcprograms/out.all"
rm ${log} ; touch ${log}
find smallcprograms -name "*.log" | xargs cat >> ${log}
echo "Log: =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
cat ${log}
