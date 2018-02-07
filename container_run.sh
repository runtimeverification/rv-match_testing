#!/bin/bash
currentscript="container_run.sh"
jenkins_folder_name="$(basename `pwd`)"
hyphen='-'
container="${jenkins_folder_name//_/$hyphen}"
echo "DEBUG 1"
echo $jenkins_folder_name
echo "DEBUG 2"
echo $container

guest_script="guest_run.sh"
guest_script_flags=" -"
while getopts ":rsatdg" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        #container="match-regression"
        guest_script_flags=$guest_script_flags"r"
      ;;
    s ) echo $currentscript" status option selected."
        guest_script_flags=$guest_script_flags"s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        #container="match-acceptance"
        guest_script_flags=$guest_script_flags"a"
      ;;
    t ) echo $currentscript" unit test option selected."
        guest_script_flags=$guest_script_flags"t"
      ;;
    d ) echo $currentscript" development option selected."
        guest_script_flags=$guest_script_flags"d"
      ;;
    g ) echo $currentscript" gcc only option selected."
        guest_script_flags=$guest_script_flags"g"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t] [-d] [-g]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d development"
         echo " -g gcc only"
      ;;
  esac
done
if [ $guest_script_flags == " -" ] ; then
    guest_script_flags=""
fi
guest_script=$guest_script$guest_script_flags
echo "`git rev-parse --verify HEAD`" > githash.ini

echo "=== Stopping (destroying) old container:"
lxc stop $container
echo "=== First listing:"
lxc list
echo "=== Copying:"
lxc copy match-testing-source $container -e
echo "=== Second listing:"
lxc list
echo "=== Setting permissions:"
chmod +x sayhi.sh
echo "=== Attach network:"
#lxc network attach testbr0 match-testing eth0
echo "=== Starting:"
lxc start $container
echo "=== Third listing:"
lxc list
echo "=== Source path:"
pwd
echo "=== Mounting:"
lxc config device add $container shared-folder-device disk source=`pwd` path=/mnt/jenkins
echo "Sleeping.."
sleep 5
lxc list
echo "=== Exec:"
lxc exec $container -- bash -c "/mnt/jenkins/$guest_script"
echo "=== End Exec"

#set -e
#function stopLxc {
#  lxc-stop -n $container
#}
#unset XDG_SESSION_ID
#unset XDG_RUNTIME_DIR
#unset XDG_SESSION_COOKIE
#lxc-destroy -f --name $container
#lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n $source_container -N $container \
#&& trap stopLxc EXIT
#lxc-info --name $container
#lxc-start --version
#lxc-checkconfig
#uname -a
#cat /proc/self/cgroup
#cat /proc/1/mounts
#lxc-info --name $source_container
#echo "Testing container's info:"
#lxc-info --name $container
#lxc-start -n $container
#lxc-attach -n $container -- su -l -c "/mnt/jenkins/$guest_script"
