#!/bin/bash
name="match-testing-source"
guest_script="rv-match_testing/source_guest_run.sh"
# Top folder is expected to contain both rv-match and rv-match_testing projects inside it.
topfolder=$(pwd)

echo "Initial lxc state:"
lxc list

echo "Deleting old $name:"
lxc delete "$name"
lxc list

echo "Creating new $name:"
lxc launch ubuntu:16.04 "$name"
lxc list

echo "Sleeping so networking should begin:"
sleep 5
lxc list

echo "Mounting $name:"
lxc config device add $name shared-folder-device-source disk source="$topfolder" path=/mnt/jenkins-source
lxc list

echo "Running script on $name"
echo "  Purpose of script:"
echo "    1. To prep apt installs"
echo "    2. To prep k-bin-to-text"
lxc exec $name -- bash -c "/mnt/jenkins-source/$guest_script"
