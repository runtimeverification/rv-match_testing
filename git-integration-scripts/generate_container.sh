#!/bin/bash
container="guest-001"
lxc copy match-testing-xenial-source $container -e
lxc config device add $container shared-folder-device disk source=`pwd` path=/mnt/jenkins
guest_script="client_run.sh"
lxc exec $container -- bash -c "/mnt/jenkins/$guest_script"
