#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
containerscriptflags=" -"
hadflag="1"
while getopts ":rsatdge" opt; do
  hadflag="0"
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
      ;;
    g ) echo $currentscript" gcc option selected."
        containerscriptflags=$containerscriptflags"g"
      ;;
    e ) echo $currentscript" use existing container option selected."
        containerscriptflags=$containerscriptflags"e"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t] [-d] [-g] [-e]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d container uses development"
         echo " -g gcc only"
         echo " -e use existing container"
      ;;
  esac
done
if [ $containerscriptflags == " -" ] ; then
    containerscriptflags=""
fi
if [ "$hadflag" == "0" ] ; then
    containerscriptflags="$containerscriptflags $2"
else
    containerscriptflags="$containerscriptflags $1"
fi

#bash copy_kcc_from_rv-match-master_to_jenkins_workspace.sh
if [ ! -f results/$exportfile.xml ] ; then
    mkdir -p results/
    touch results/$exportfile.xml
fi
chmod a+rw results/$exportfile.xml
#ls -la results/
bash container_run.sh$containerscriptflags
