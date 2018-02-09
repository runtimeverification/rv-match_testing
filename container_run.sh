#!/bin/bash
currentscript="container_run.sh"
jenkins_folder_name="$(basename `pwd`)"
hyphen='-'
container="${jenkins_folder_name//_/$hyphen}"
guest_script="guest_run.sh"
guest_script_flags=" -"
use_existing_container="1"
hadflag="1"
while getopts ":rsatdge" opt; do
  hadflag="0"
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
    e ) echo $currentscript" use existing container option selected."
        use_existing_container="0"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t] [-d] [-g] [-e]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d development"
         echo " -g gcc only"
         echo " -e use existing container"
      ;;
  esac
done
if [ "$guest_script_flags" == " -" ] ; then
    guest_script_flags=""
fi
echo "$currentscript 1: '$1' 2: '$2'"
if [ "$hadflag" == "0" ] ; then
    guest_script_flags="$guest_script_flags $2"
    echo "choosing 2"
else
    guest_script_flags="$guest_script_flags $1"
    echo "choosing 1"
fi
guest_script=$guest_script$guest_script_flags
echo "`git rev-parse --verify HEAD`" > githash.ini
if [ ! "$use_existing_container" == "0" ] ; then
    echo "=== Stopping (destroying) old container:"
    lxc stop $container
    echo "=== First listing:"
    lxc list
    echo "=== Copying:"
    lxc copy match-testing-source $container -e
    echo "=== Second listing:"
    lxc list
    echo "=== Starting:"
    lxc start $container
    echo "=== Third listing:"
else
    echo "Attaching to the existing container, $container, in:"
fi
lxc list
echo "=== Source path:"
pwd
echo "=== Mounting:"
lxc config device add $container shared-folder-device disk source=`pwd` path=/mnt/jenkins
echo "Sleeping.."
sleep 5
lxc list
echo "=== Exec:"
echo "$currentscript calling '$guest_script'"
lxc exec $container -- bash -c "/mnt/jenkins/$guest_script"
echo "=== End Exec"
