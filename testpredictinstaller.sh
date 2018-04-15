#!/bin/bash

set +e
type rvpc ; check=$?
set -e
wget -q https://runtimeverification.com/predict/1.9.1-SNAPSHOT/c/rv-predict-c-installer-1.9.1-SNAPSHOT.jar
mv rv-predict-c-installer-1.9.1-SNAPSHOT.jar predict-c.jar
printf "


1
1
1
" > stdinfile.txt
if [ "$check" == "0" ] ; then
	uninstall
fi

install() {
	cat stdinfile.txt | sudo java -jar predict-c.jar -console
	which rvpc
	rvpc -help
}

uninstall() {
	sudo dpkg -r rv-predict-c
}

install ; uninstall ; install ; uninstall
