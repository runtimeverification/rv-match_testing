#!/bin/bash
currentscript="container_run.sh"
defaultcontainer="rv-match_projtesting_container"
container=$defaultcontainer
source_container="ubuntu-14.04-java"
guest_script="guest_run.sh"
while getopts ":rsat" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        container="rv-match_regression_container"
        guest_script=$guest_script" -r"
      ;;
    s ) echo $currentscript" status option selected."
        container=$defaultcontainer
        guest_script=$guest_script" -s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        container="rv-match_acceptance_container"
        guest_script=$guest_script" -a"
      ;;
    t ) echo $currentscript" unit test option selected."
        #container="rv-match_unittest_container"
        guest_script=$guest_script" -t"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
      ;;
  esac
done
echo "`git rev-parse --verify HEAD`" > githash.ini

set -e
function stopLxc {
  lxc-stop -n $container
}
unset XDG_SESSION_ID
unset XDG_RUNTIME_DIR
unset XDG_SESSION_COOKIE
#lxc-destroy -f --name $container
lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n $source_container -N $container \
&& trap stopLxc EXIT
lxc-info --name $container
lxc-start --version
lxc-checkconfig
uname -a
cat /proc/self/cgroup
cat /proc/1/mounts
lxc-info --name $source_container
echo "Testing container's info:"
lxc-info --name $container
lxc-start -n $container
lxc-attach -n $container -- su -l -c "/mnt/jenkins/$guest_script"
