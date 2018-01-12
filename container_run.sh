#!/bin/bash
currentscript="container_run.sh"
source_container_trusty="ubuntu-14.04-java"
source_container_zesty="ubuntu-zesty-source-rv-match_testing"
defaultcontainer="rv-match_projtesting_container"
defaultcontainer="rv-match_testing_container"
container=$defaultcontainer
source_container=$source_container_zesty
guest_script="guest_run.sh"
while getopts ":rsa" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        container="rv-match_regression_container"
        guest_script=$guest_script" -r"
        source_container=$source_container_trusty
      ;;
    s ) echo $currentscript" status option selected."
        container=$defaultcontainer
        guest_script=$guest_script" -s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        container="rv-match_acceptance_container"
        guest_script=$guest_script" -a"
        source_container=$source_container_trusty
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
      ;;
  esac
done

set -e
function stopLxc {
    lxc-stop -n $container
}
unset XDG_SESSION_ID
unset XDG_RUNTIME_DIR
unset XDG_SESSION_COOKIE
echo "source_container: $source_container"
echo "container: $container"
if [[ `lxc-ls` == *"rv-match_testing_container"* ]] ; then
    echo "Temporary container destroying."
    lxc-destroy -f -n rv-match_testing_container
fi
#ls ~/.config/lxc
# mkdir -p ~/.config/lxc
# echo "lxc.id_map = u 0 494216 65536" > ~/.config/lxc/default.conf
# echo "lxc.id_map = g 0 494216 65536" >> ~/.config/lxc/default.conf
# echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
# echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
if [[ `lxc-ls` == *"ubuntu-zesty-source-rv-match_testing"* ]] ; then 
    echo "Source container destroying."
    lxc-destroy -f -n ubuntu-zesty-source-rv-match_testing
fi
lxc-checkconfig
lxc-create -t download -n $source_container -- -d ubuntu -r zesty -a amd64
lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n $source_container -N $container \
#&& trap stopLxc EXIT
lxc-checkconfig
uname -a
lxc-info --name $container
lxc-start -n $container
lxc-attach -n $container -- su -l -c "/mnt/jenkins/source_guest_setup.sh"

#lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n $source_container -N $container \
#&& trap stopLxc EXIT
#lxc-info --name $container
#lxc-start --version
#lxc-checkconfig
#uname -a
#cat /proc/self/cgroup
#cat /proc/1/mounts
#lxc-info --name $source_container
#lxc-info --name $container
#lxc-start -n $container
#lxc-attach -n $container -- su -l -c "/mnt/jenkins/$guest_script"
