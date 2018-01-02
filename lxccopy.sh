#!/bin/bash
set -e
function stopLxc {
  lxc-stop -n rv-match_projtesting_container
}
unset XDG_SESSION_ID
unset XDG_RUNTIME_DIR
unset XDG_SESSION_COOKIE
#lxc-destroy -f --name rv-match_projtesting_container
lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n ubuntu-14.04-java -N rv-match_projtesting_container \
&& trap stopLxc EXIT
lxc-info --name rv-match_projtesting_container
lxc-start --version
lxc-checkconfig
uname -a
cat /proc/self/cgroup
cat /proc/1/mounts
lxc-info --name ubuntu-14.04-java
lxc-info --name rv-match_projtesting_container
lxc-start --name rv-matchprojtesting_container
lxc-attach -n rv-match_projtesting_container -- su -l -c /mnt/jenkins/echohello.sh
