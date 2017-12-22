#!/bin/bash
set -e
function stopLxc {
  lxc-stop -n rv-match_projtesting_container
}
unset XDG_SESSION_ID
unset XDG_RUNTIME_DIR
unset XDG_SESSION_COOKIE
lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n ubuntu-14.04-java -N rv-match_projtesting_container \
&& trap stopLxc EXIT
lxc-info --name rv-match_projtesting_container
lxc network create testbr0
lxc network show testbr0
lxc network attach testbr0 rv-match_projtesting_container default eth0
lxc-info --name ubuntu-14.04-java
lxc-info --name rv-match_projtesting_container
lxc-attach -n rv-match_projtesting_container -- su -l -c /mnt/jenkins/echohello.sh
