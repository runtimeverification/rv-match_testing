#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
containerscriptflags=" -"
while getopts ":rsatd" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        containerscriptflags=$containerscriptflags"r"
      ;;
    s ) echo $currentscript" status option selected."
        exportfile="status"
        containerscriptflags=$containerscriptflags"s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
        containerscriptflags=$containerscriptflags"a"
      ;;
    t ) echo $currentscript" unittest option selected."
        containerscriptflags=$containerscriptflags"t"
      ;;
    d ) echo $currentscript" git development checkout option selected."
        containerscriptflags=$containerscriptflags"d"
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t] [-d]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d container uses development"
      ;;
  esac
done
if [ $containerscriptflags == " -" ] ; then
    containerscriptflags=""
fi

bash copy_kcc_from_rv-match-master_to_jenkins_workspace.sh
#touch results/$exportfile.xml
#chmod 777 results/$exportfile.xml
#ls -la results/
bash container_run.sh$containerscriptflags
