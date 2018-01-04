#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
containerscriptflags=""
while getopts ":rs" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        containerscriptflags=" -r"
      ;;
    s ) echo $currentscript" status option selected."
        exportfile="status"
        containerscriptflags=" -s"
      ;;
    \? ) echo "Usage: cmd [-r]"
         echo " -r regression"
      ;;
  esac
done

bash copy_kcc_dependencies.sh
chmod 777 results/$exportfile.xml
ls -la results/
bash container_run.sh$containerscriptflags
