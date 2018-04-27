#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
hadflag="1"
usetrusty="1"
useoldmachine="1"
while getopts ":raTo" opt; do
	hadflag="0"
	case ${opt} in
		r )
			exportfile="regression"
			;;
		a )
			exportfile="acceptance"
			;;
		T )
			usetrusty=0
			;;
		o)
			useoldmachine=0
			;;
	esac
done
if [ ! -f results/$exportfile.xml ] ; then
    mkdir -p results/
    touch results/$exportfile.xml
fi
chmod a+rw results/$exportfile.xml
chmod a+rw logs/
if [ "$useoldmachine" == "0" ] ; then
    bash copy_kcc_from_rv-match-master_to_jenkins_workspace.sh
fi
echo "$currentscript Build number: ${BUILD_NUMBER}"
bash container_run.sh "$@"
