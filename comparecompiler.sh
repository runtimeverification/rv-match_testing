#!/bin/bash
log="smallcprograms/out.log"
rm ${log} ; touch ${log}
for tt in smallcprograms/*.c; do
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
	echo -e "\r${name} complete.                           "
done
echo "Log: =-=-=-=-=-=-=-=-=-=-=-=-=-="
cat ${log}
