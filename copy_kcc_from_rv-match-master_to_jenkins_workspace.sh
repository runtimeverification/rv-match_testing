#!/bin/bash
currentdir=$(pwd)
#kccsource="/var/lib/jenkins/jobs/rv-match-master-copy/workspace"
#kccsource="/var/jenkins/workspace/rv-match-master-copy"
#kccsource="~chrishathhorn/rv-match"
cd $kccsource
echo "Should be inside the proper jenkins folder to get kcc from..."
pwd
ls
kccgithash=$(git rev-parse HEAD)
cd $currentdir
rm -r kcc_dependency_1/
rm -r kcc_dependency_2/
rm -r kcc_dependency_3/
#cp -r $kccsource/c-semantics/dist ./kcc_dependency_1/
#cp -r $kccsource/errors/rv-error/bin ./kcc_dependency_2/
mkdir kcc_dependency_3/
#cp -r $kccsource/k/k-distribution/target/release/k/bin ./kcc_dependency_3/bin
#cp -r $kccsource/k/k-distribution/target/release/k/lib ./kcc_dependency_3/lib
scp rv-server-1:/home/chrishathhorn/rv-match/c-semantics/dist ./kcc_dependency_1/
scp rv-server-1:/home/chrishathhorn/rv-match/errors/rv-error/bin ./kcc_dependency_2/
scp rv-server-1:/home/chrishathhorn/rv-match/k/k-distribution/target/release/k/bin ./kcc_dependency_3/bin
scp rv-server-1:/home/chrishathhorn/rv-match/k/k-distribution/target/release/k/lib ./kcc_dependency_3/lib
cd $kccsource
kccgithash2=$(git rev-parse HEAD)
echo "rv-match git hash before copying kcc: "$kccgithash
echo "rv-match git hash after  copying kcc: "$kccgithash2
if [[ $kccgithash != $kccgithash2 ]] ; then
    echo "Warning: git hash changed during copy."
else
    echo "Git hash remained the same during copy."
fi
cd $currentdir
cd kcc_dependency_1/ ; ls ; cd ..
cd kcc_dependency_2/ ; ls ; cd ..
cd kcc_dependency_3/ ; ls ; cd ..
