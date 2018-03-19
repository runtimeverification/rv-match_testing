#!/bin/bash
currentscript="container_run.sh"
jenkins_folder_name="$(basename `pwd`)"
hyphen='-'
container="${jenkins_folder_name//_/$hyphen}"
guest_script="guest_run.sh"
guest_script_flags=" -"
use_existing_container="1"
hadflag="1"
stop_container="0"
source_container="match-testing-xenial-source"
oldmachine="1"
while getopts ":rsatdgeEqpPTob" opt; do
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
    E ) echo $currentscript" leave container alive option selected."
        stop_container="1"
      ;;
    q ) echo $currentscript" quick (don't update rv-match) option selected."
        guest_script_flags=$guest_script_flags"q"
      ;;
    p ) echo $currentscript" prepare option selected."
        guest_script_flags=$guest_script_flags"p"
      ;;
    P ) echo $currentscript" rv-predict option selected."
        guest_script_flags=$guest_script_flags"P"
      ;;
    T ) echo $currentscript" Trusty option selected."
        source_container="match-testing-trusty-source"
        guest_script_flags=$guest_script_flags"T"
      ;;
    o ) echo $currentscript" other machine option selected."
        guest_script_flags=$guest_script_flags"o"
        oldmachine="0"
      ;;
    b ) echo $currentscript" force build option selected."
        guest_script_flags=$guest_script_flags"b"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t] [-d] [-g] [-e] [-E] [-q] [-p] [-P] [-T] [-o] [-b]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d development"
         echo " -g gcc only"
         echo " -e use existing container"
         echo " -E leave container alive"
         echo " -q don't update rv-match"
         echo " -p prepare only"
         echo " -P rv-predict"
         echo " -T Trusty"
         echo " -o other machine"
         echo " -b force build"
      ;;
  esac
done
echo "$currentscript Build number: ${BUILD_NUMBER}"
if [ "$guest_script_flags" == " -" ] ; then guest_script_flags="" ; fi
if [ "$hadflag" == "0" ] ; then flag=$2 ; else flag=$1 ; fi
guest_script_flags="$guest_script_flags $flag"
guest_script=$guest_script$guest_script_flags

# Copy, boot up, run guest script on, and shut down container
if [ "$oldmachine" == "0" ] ; then
    # Branch for lxc, old machine containerization
    
    source_container="ubuntu-14.04-java"
    container="rv-match_testing_container"
    function stopLxc {
        lxc-stop -n $container
    }
    unset XDG_SESSION_ID
    unset XDG_RUNTIME_DIR
    unset XDG_SESSION_COOKIE
    echo "source_container: $source_container"
    echo "container: $container"

    if [[ `lxc-ls` == *"$container"* ]] && [ ! $use_existing_container == "0" ] ; then
        echo "Temporary container destroying."
        lxc-destroy -f -n $container
    else
        echo "Bash claims the following list does not have $container:"
        lxc-ls
        echo "End list. "
    fi

    # The following script comment is for setting up networking for the lxc containerization.
    # 
    # < configuration >
    # ls ~/.config/lxc
    # mkdir -p ~/.config/lxc
    # echo "lxc.id_map = u 0 494216 65536" > ~/.config/lxc/default.conf
    # echo "lxc.id_map = g 0 494216 65536" >> ~/.config/lxc/default.conf
    # echo "lxc.network.type = veth" >> ~/.config/lxc/default.conf
    # echo "lxc.network.link = lxcbr0" >> ~/.config/lxc/default.conf
    # < / configuration >

    lxc-destroy -f -n ubuntu-temp-trusty-source-rv-match_testing
    lxc-destroy -f -n rv-match_regression_container
    lxc-checkconfig
    #lxc-create -t download -n $some_source_container -- -d ubuntu -r trusty -a amd64
    lxc-copy -s -e -B overlay -m bind=`pwd`:/mnt/jenkins:rw -n $source_container -N $container \
    && trap stopLxc EXIT
    lxc-checkconfig
    uname -a
    cat /proc/self/cgroup
    cat /proc/1/mounts
    lxc-info --name $container
    lxc-start -n $container
    lxc-ls
    sleep 5
    lxc-ls
    lxc-attach -n $container -- su -l -c "/mnt/jenkins/$guest_script"
else
    # Branch for lxd, new machine containerization

    lxc info $container &> /dev/null ; container_exists="$?"
    if [ ! "$container_exists" == "0" ] ; then
        use_existing_container="2"
    fi
    if [ ! "$use_existing_container" == "0" ] ; then
        echo "=== Stopping (destroying) old container:"
        lxc exec $container -- poweroff
        sleep 2
        lxc stop $container --force
        echo "=== First listing:"
        lxc list
        echo "=== Copying:"
        lxc copy $source_container $container -e
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
    echo "$currentscript: '$guest_script'"
    lxc config set $container environment.BUILD_NUMBER "${BUILD_NUMBER}"
    lxc exec $container -- bash -c "/mnt/jenkins/$guest_script"
    echo "=== End Exec"
    if [ "$stop_container" == "0" ] ; then
        echo "=== Stopping $container"
        lxc stop $container --force
        echo "=== Stopped  $container"
    else
        echo "$container was left running because of the -E option."
        echo "You can access it with:"
        echo "\"lxc exec $container -- bash\""
        echo "Or stop it with: \"lxc stop $container\""
    fi
fi
