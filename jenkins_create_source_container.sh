#!/bin/bash

# Code to put into jenkins job 'rv-match_prepare_source_container' which auto-checks-out rv-match:
# Last updated 8 February 2018
# #git clone https://github.com/runtimeverification/rv-match_testing.git
# cd rv-match_testing/
# git checkout master
# git reset --hard origin/master
# git checkout master
# git pull
# chmod a+x source_guest_run.sh
# cd ..
# bash rv-match_testing/jenkins_create_source_container.sh

set -e

if [ "$1" == "xenial" ] ; then
    name="match-testing-xenial-source"
    version="16.04"
else
    if [ "$1" == "trusty" ] ; then
        name="match-testing-trusty-source"
        version="14.04"
    else
        echo "Need argument (xenial|trusty)."
        exit 1
    fi
fi

guest_script="rv-match_testing/source_guest_run.sh"
# Top folder is expected to contain both rv-match and rv-match_testing projects inside it.

echo "Initial container and contents:"
initialfolder=$(pwd)
pwd ; ls

echo "Initial lxc state:"
lxc list

if lxc info $name ; then
    echo "Shutting down old $name:"
    lxc exec $name -- poweroff
    sleep 5

    echo "Stopping old $name:"
    lxc stop "$name"
    sleep 5

    echo "Deleting old $name:"
    lxc delete --force "$name"
    lxc list
else
    echo "Existing $name was not found so we skip shut down, stop, and delete steps."
fi

echo "Creating new $name:"
lxc launch ubuntu:$version "$name"
lxc list

echo "Sleeping so networking should begin:"
sleep 5
lxc list

echo "Mounting $name:"
lxc config device add $name shared-folder-device-source disk source="$initialfolder" path=/mnt/jenkins-source
lxc list

echo "Running $guest_script on $name"
set -e ; lxc exec $name -- bash -c "/mnt/jenkins-source/$guest_script"

echo "Stopping $name. ($name should be persistent.)"
lxc stop $name
