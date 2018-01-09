#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
containerscriptflags=""
while getopts ":rsa" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        containerscriptflags=" -r"
      ;;
    s ) echo $currentscript" status option selected."
        exportfile="status"
        containerscriptflags=" -s"
      ;;
    a ) echo $currentscript" status option selected."
        exportfile="acceptance"
        containerscriptflags=" -a"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
      ;;
  esac
done

bash copy_kcc_dependencies.sh
touch results/$exportfile.xml
chmod 777 results/$exportfile.xml
ls -la results/
bash container_run.sh$containerscriptflags
