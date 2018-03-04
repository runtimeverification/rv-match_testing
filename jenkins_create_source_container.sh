#!/bin/bash

# Code to put into jenkins job 'rv-match_prepare_source_container' which auto-checks-out rv-match:
# Last updated 27 February 2018:
#
# < script >
# #git clone https://github.com/runtimeverification/rv-match_testing.git
# cd rv-match_testing/
# git checkout master
# git reset --hard origin/master
# git checkout master
# git pull
# chmod a+x source_guest_run.sh
# cd ..
# bash rv-match_testing/jenkins_create_source_container.sh
# < / script >

set -e

if [ "$1" == "xenial" ] ; then
    name="xenial-temp-source"
    final_name="match-testing-xenial-source"
    version="16.04"
else
    if [ "$1" == "trusty" ] ; then
        name="trusty-temp-source"
        final_name="match-testing-trusty-source"
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

clean_delete() {

    if lxc info $1 ; then
        # We don't care if shut down or stop commands fail.
        set +e
        echo "Shutting down old $1:"
        lxc exec $1 -- poweroff
        sleep 5

        echo "Stopping old $1:"
        lxc stop "$1"
        sleep 5

        # We care if the delete command fails.
        set -e
        echo "Deleting old $1:"
        lxc delete --force "$1"
        set +e ; lxc info $1 &> /dev/null ; testme="$?" ; set -e
        [ ! "$testme" == "0" ]
    else
        echo "Existing $1 was not found so we skip shut down, stop, and delete steps."
    fi

}

clean_delete "$name"

echo "Creating new $name:"
lxc launch ubuntu:$version "$name"

echo "Sleeping so networking should begin."
sleep 5

echo "Mounting $name:"
lxc config device add $name shared-folder-device-source disk source="$initialfolder" path=/mnt/jenkins-source

echo "Running $guest_script on $name."
set -e ; lxc exec $name -- bash -c "/mnt/jenkins-source/$guest_script"

echo "Stopping $name. ($name should be persistent.)"
lxc stop $name

clean_delete "$final_name"

echo "Copying from temporary $name to final $final_name."
lxc copy $name $final_name

clean_delete "$name"

echo "$name should be deleted and $final_name should exist:"
lxc list
