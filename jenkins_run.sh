#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
containerscriptflags=" -"
hadflag="1"
usetrusty="1"
useoldmachine="1"
while getopts ":rsatdgeEqpPTob" opt; do
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
    E ) echo $currentscript" leave container alive option selected."
        containerscriptflags=$containerscriptflags"E"
      ;;
    q ) echo $currentscript" quick (don't update rv-match) option selected."
        containerscriptflags=$containerscriptflags"q"
      ;;
    p ) echo $currentscript" prep option selected. (lowercase 'p')"
        containerscriptflags=$containerscriptflags"p"
      ;;
    P ) echo $currentscript" rv-predict option selected. (uppercase 'P')"
        containerscriptflags=$containerscriptflags"P"
      ;;
    T ) echo $currentscript" Trusty option selected."
        containerscriptflags=$containerscriptflags"T"
        usetrusty="0"
      ;;
    o ) echo $currentscript" other (old) machine option selected."
        containerscriptflags=$containerscriptflags"o"
        useoldmachine="0"
      ;;
    b ) echo $currentscript" force build option selected."
        containerscriptflags=$containerscriptflags"b"
      ;;
    \? ) echo "Usage: $currentscript [-r] [-s] [-a] [-t] [-d] [-g] [-e] [-E] [-q] [-p] [-P] [-T] [-o] [-b]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d container uses development"
         echo " -g gcc only"
         echo " -e use existing container"
         echo " -E leave container alive"
         echo " -q don't update rv-match"
         echo " -p prepare only"
         echo " -P rv-predict option selected"
         echo " -T use Trusty"
         echo " -o other machine"
         echo " -b force build"
      ;;
  esac
done
if [ "$containerscriptflags" == " -" ] ; then
    containerscriptflags=""
fi
if [ "$hadflag" == "0" ] ; then flag=$2 ; else flag=$1 ; fi
containerscriptflags="$containerscriptflags $flag"
if [ ! -f results/$exportfile.xml ] ; then
    mkdir -p results/
    touch results/$exportfile.xml
fi
chmod a+rw results/$exportfile.xml
chmod a+rw logs/
if [ "$useoldmachine" == "0" ] ; then
    bash copy_kcc_from_rv-match-master_to_jenkins_workspace.sh
fi
bash container_run.sh$containerscriptflags
