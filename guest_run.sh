#!/bin/bash
echo "`basename "$0"` $@"
currentscript="guest_run.sh"
hostspace="/mnt/jenkins"
# This is the initial script ran from inside the lxc/lxd container.
# Called by: container_run.sh
# Calls    : libs.sh, run-set.sh

exportfile="report"
runsetparams=" -"
development_checkout_check="0"
unittestsetprefix=""
hadflag="1"
reinstallmatch="0"
rvpredict="1"
othermachine="1"
selfunittests="0"
quickoption="1"
echo "========= Beginning container guest scripts."
while getopts ":rsatdgqpPobJ" opt; do
	hadflag="0"
	case ${opt} in
                r )
                        exportfile="regression"
                        ;;
                a )
                        exportfile="acceptance"
                        ;;
                t )
                        unittestsetprefix="unit_"
                        ;;
                d)
                        development_checkout_check=1
                        ;;
                g)
                        reinstallmatch=1
                        ;;
                q)
                        reinstallmatch=1
                        selfunittests=1
                        quickoption=0
                        ;;
                P)
                        rvpredict=0
                        reinstallmatch=1
                        ;;
                o)
                        othermachine=0
                        ;;
        esac
done

echo "$currentscript Build number: ${BUILD_NUMBER}"
if [ "$runsetparams" == " -" ] ; then runsetparams="" ; fi
if [ "$hadflag" == "0" ] ; then flag=$2 ; else flag=$1 ; fi
runsetparams="$runsetparams $flag"

# Container log marker
echo "Entered container at: "$(pwd)

# Assert network functionality in container
printf "\n<$currentscript assert network>\n"
set -e
ping -c 1 www.google.com
set +e
echo "</$currentscript assert network>"

# Assert k-bin-to-text functionality
if [ "$othermachine" == "0" ] ; then
    cp /mnt/jenkins/libs.sh .
    bash libs.sh$runsetparams
else
    printf "\n<$currentscript assert k-bin-to-text>\n"
    export PATH=/root/rv-match/k/k-distribution/target/release/k/bin:$PATH
    k-bin-to-text ; testout=$(echo "$?")
    set -e
    printf "\n  'which' test:\n"
    which k-bin-to-text
    printf "\n  'return value with empty arguments is 1' test:\n"
    [ "$testout" == "1" ]
    set +e
    echo "</$currentscript assert k-bin-to-text>"
fi

# Update rv-match_testing
cd /root/
if [ ! -d rv-match_testing ] ; then
    echo "rv-match_testing should already be here from the source container" ; exit 1
    git clone https://github.com/runtimeverification/rv-match_testing.git
fi
cd rv-match_testing/
gitbranch="master"
if [ "$development_checkout_check" == "1" ] ; then
    echo "Git branch development checked out."
    gitbranch="development"
else
    echo "Git branch master checked out."
fi
git checkout $gitbranch
git reset --hard origin/$gitbranch
git checkout $gitbranch
git pull

# Update rvpc

#  Reference:
#   RV-Predict/Java: `https://runtimeverification.com/predict/1.9.1-SNAPSHOT/rv-predict-installer-1.9.1-SNAPSHOT.jar`
#   RV-Predict/C debian: `https://runtimeverification.com/predict/1.9.1-SNAPSHOT/c/rv-predict-c_1.9.1-SNAPSHOT-1_amd64.deb`
#   RV-Predict/C gui: `https://runtimeverification.com/predict/1.9.1-SNAPSHOT/c/rv-predict-c-installer-1.9.1-SNAPSHOT.jar`
#   Should no longer need to use: https://runtimeverification.com/predict/download/c?v=1.9
#   Should no longer need to use: https://runtimeverification.com/predict/download/java?v=1.9

waitmanage() {
	while fuser /var/lib/dpkg/lock || fuser /var/lib/apt/lists/lock ; do
		waitstr="because this should actually be a do-while loop"
		if fuser /var/lib/dpkg/lock ; then
			waitstr="on the dpkg lock"
		fi
		if fuser /var/lib/apt/lists/lock ; then
			waitstr="on the 'apt lists' lock"
		fi
		printf "\nWaiting ${waitstr} before ${1}."
		sleep 5
	done
	fuser /var/lib/dpkg/lock      ; echo "     dpkg lock check: [$?]"
	fuser /var/lib/apt/lists/lock ; echo "apt lists lock check: [$?]"
}

if [ "$rvpredict" == "0" ] ; then
    echo "<install rv-predict>"
    echo "  Existing version:"
    rvpc --version
    #cd /root/ ; wget -q https://runtimeverification.com/predict/1.9.1-SNAPSHOT/c/rv-predict-c-installer-1.9.1-SNAPSHOT.jar
    cd /root/ ; wget -q https://runtimeverification.com/predict/1.9.1-SNAPSHOT/c/rv-predict-c_1.9.1-SNAPSHOT-1_amd64.deb
    #rm -f predict-c-old.jar
    rm -f predict-c-old.deb
    #mv predict-c.jar predict-c-old.jar &> /dev/null
    mv predict-c.deb predict-c-old.deb &> /dev/null
    set -e
    #mv rv-predict-c-installer-1.9.1-SNAPSHOT.jar predict-c.jar
    mv rv-predict-c_1.9.1-SNAPSHOT-1_amd64.deb predict-c.deb
    set +e
    #diff predict-c.jar predict-c-old.jar &> /dev/null ; predictissame="$?"
    diff predict-c.deb predict-c-old.deb &> /dev/null ; predictissame="$?"
    which rvpc &> /dev/null ; predictinstalled="$?"
    if [ "$quickoption" == "0" ] ; then
        installpredict="2"
    else
        #if [ -e predict-c-old.jar ] && [ "$predictissame" == "0" ] && [ "$predictinstalled" == "0" ] ; then
        if [ -e predict-c-old.deb ] && [ "$predictissame" == "0" ] && [ "$predictinstalled" == "0" ] ; then
            installpredict="1"
        else
            installpredict="0"
        fi
    fi
    if [ ! "$installpredict" == "0" ] ; then
        echo "  New predict file is the same as the old one or -q and rvpc is installed. Not updating."
    else
        echo "  Old predict file not found or differs. Updating with new."
        sudo dpkg -r rv-predict-c &> /dev/null
	echo "  <assert rvpc uninstalled before reinstall>"
        waitmanage "asserting rvpc is uninstalled"
	rvpc --version &> /dev/null ; rvpcstillinstalled="$?"
	if [ "$rvpcstillinstalled" == "0" ] ; then
		echo "After running 'sudo dpkg -r rv-predict-c', somehow 'rvpc --version' gives: {"
		rvpc --version ; echo "} with exit code [$?]. Exiting."
		exit 1
	fi
	# Delete next line if the exit 1 above is still around.
        #set -e ; [ ! "$rvpcstillinstalled" == "0" ] ; set +e
        echo "  </assert rvpc uninstalled before reinstall>"
        waitmanage "before updating apt"
	#printf "
#
#
#1
#1
#1
#" > stdinfile.txt
        #cat stdinfile.txt | sudo java -jar predict-c.jar -console
        sudo apt-get update # deb line 1 of 3
        waitmanage "installing predict-c debian"
	sudo dpkg -i predict-c.deb # deb line 2 of 3
        waitmanage "apt fix-broken installing"
	sudo apt-get install -f -y # deb line 3 of 3
        sleep 1
        echo "  Version after reinstall:"
        rvpc --version
    fi
    echo "  <assert rvpc>"
    set -e
    which rvpc &> /dev/null
    rvpc -help &> /dev/null
    set +e
    echo "  </assert rvpc>"
    echo "</install rv-predict>"
fi

# Update kcc
if [ "$othermachine" == "0" ] ; then
    cd /root/
    rm -rf kcc_dependency_1/
    rm -rf kcc_dependency_2/
    rm -rf kcc_dependency_3/
    cp -r /mnt/jenkins/kcc_dependency_1/ .
    cp -r /mnt/jenkins/kcc_dependency_2/ .
    mkdir kcc_dependency_3/
    cp -r /mnt/jenkins/kcc_dependency_3/bin/ ./kcc_dependency_3/
    cp -r /mnt/jenkins/kcc_dependency_3/lib/ ./kcc_dependency_3/
    export PATH=/root/kcc_dependency_1:/root/kcc_dependency_2:/root/kcc_dependency_3/bin:$PATH
    #mvn package # in k folder
    set -e
    which kcc
    kcc -v
    set +e
else
    # https://github.com/runtimeverification/rv-match/blob/master/installer-linux/scripts/install-in-container
    cd /root/
    mv rv-match-linux-64-1.0-SNAPSHOT.jar rv-match-linux-64-1.0-SNAPSHOT.jar.old
    wget -q https://runtimeverification.com/match/1.0/rv-match-linux-64-1.0-SNAPSHOT.jar
    diff rv-match-linux-64-1.0-SNAPSHOT.jar rv-match-linux-64-1.0-SNAPSHOT.jar.old ; checknew="$?"
    kcc -v ; checkinstalled="$?"
    if [ "$checknew" == "0" ] && [ "$checkinstalled" == "0" ] ; then
        reinstallmatch="2"
    fi
    if [ ! "$reinstallmatch" == "0" ] ; then
        echo "Not installing rv-match since both of these two criterion hold:"
        echo "1. Already downloaded .jar matches the new."
        echo "2. \"kcc -v\" functions."
        echo "And we are assuming based on that that rv-match is already installed and updated to the latest version."
        echo "Or the -q, -P, or -g option was used."
    else
        if [ "$checknew" == 0 ] ; then
            echo "\"kcc -v\" doesn't function, even though the new version matches the old."
            echo "Therefore, we will attempt install of rv-match."
        else
            echo "Either the new rv-match differs from the old or the old doesn't exist, so we will install it."
        fi
        (echo "" | /opt/rv-match/uninstall 2> /dev/null) 2> /dev/null
        sudo rm -f /usr/bin/rv-match
        printf "
1


1
y
1
1
" > stdinfile.txt
        cat stdinfile.txt | java -jar rv-match-linux-64*.jar -console 2> /dev/null ; rm stdinfile.txt
    fi
fi

# Assert rv-match_testing minimum requirements
if [ "$selfunittests" == "0" ] ; then
    echo "<$currentscript assert self-unit-tests>"
    cd /root/rv-match_testing
    bash unit_test_run-set.sh &> selfunittest.log ; testout=$(echo "$?")
    if [ "$testout" == "0" ] ; then
        echo "  self-unit-tests all passed."
    else
        if [ "$testout" == "1" ] ; then
            echo "  self-unit-test(s) failed."
        else
            echo "  self-unit-tests did not process properly."
        fi
        cat selfunittest.log
    fi
    set -e
    [ "$testout" == "0" ]
    set +e
    echo "</$currentscript assert self-unit-tests>"
else
    echo "[self-unit-tests skipped]"
fi

# Run test script, where most of the work happens
cd /root/rv-match_testing && bash run-set.sh "$@"

# Container copies results from itself to host
echo "Container results are in $exportfile.xml:"
cat results/$exportfile.xml
echo "Copying results to host now."
cp results/$exportfile.xml $hostspace/results/ && rm results/$exportfile.xml
echo "========== Finished container guest scripts."
