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
    t ) echo $currentscript" status option selected."
        exportfile="unittest"
        containerscriptflags=" -t"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
      ;;
  esac
done

bash copy_kcc_from_rv-match-master_to_jenkins_workspace.sh
#touch results/$exportfile.xml
#chmod 777 results/$exportfile.xml
#ls -la results/
bash container_run.sh$containerscriptflags
