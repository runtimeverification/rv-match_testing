#!/bin/bash
currentscript="container_run.sh"
jenkins_folder_name="$(basename `pwd`)"
hyphen='-'
container="${jenkins_folder_name//_/$hyphen}"
guest_script="guest_run.sh"
guest_script_flags=" -"
while getopts ":rsatdg" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        guest_script_flags=$guest_script_flags"r"
      ;;
    s ) echo $currentscript" status option selected."
        guest_script_flags=$guest_script_flags"s"
      ;;
    a ) echo $currentscript" acceptance option selected."
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

#echo "=== Stopping (destroying) old container:"
#lxc stop $container
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
