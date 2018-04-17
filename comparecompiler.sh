#!/bin/bash
set -a
doit() {
	tt=$1
	name=$(basename ${tt})
        #echo "tt is ${tt}"
        printf "\n===[${name}]=========================\n\n" >> ${log}
        echo ${tt} >> ${log}
        cat ${tt} >> ${log}
        echo -n "${name}...     "
        while read cc; do
                #echo "cc is ${cc}"
                printf "\n---[compile, ${cc}, ${name}]--------------------------------\n" >> ${log}
                echo -en "\r[compiling, ${cc}, ${name}]...     "
                ${cc} ${tt} &>> ${log}
                printf "\n* *[runtime, ${cc}, ${name}] * * * * * * * * * * * * * * * *\n" >> ${log}
                echo -en "\r[  running, ${cc}, ${name}]...     "
                ./a.out &>> ${log}
        done <smallcprograms/compilers.ini
        echo -e "\r${name} complete."
}

log="smallcprograms/out.log"
rm ${log} ; touch ${log}
find smallcprograms -name "*.c" | parallel --eta --timeout 500 "doit {}"
echo "Log: =-=-=-=-=-=-=-=-=-=-=-=-=-="
cat ${log}
