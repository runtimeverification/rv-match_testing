#!/bin/bash
currentdir=$(pwd)
kccsource="/var/lib/jenkins/jobs/rv-match-master/workspace"
cd $kccsource
kccgithash=$(git rev-parse HEAD)
echo $kccgithash
cd $currentdir
rm -r kcc_dependency_1/
rm -r kcc_dependency_2/
rm -r kcc_dependency_3/
cp -r $kccsource/c-semantics/dist ./kcc_dependency_1/
cp -r $kccsource/errors/rv-error/bin ./kcc_dependency_2/
cp -r $kccsource/k/k-distribution/target/release/k/bin ./kcc_dependency_3/
cd $kccsource
kccgithash2=$(git rev-parse HEAD)
echo "first hash "$kccgithash
echo "next  hash "$kccgithash2
if [[ $kccgithash != $kccgithash2 ]] ; then
    echo "Warning: git hash changed during copy."
else
    echo "Git hash remained the same during copy."
fi
cd $currentdir
cd kcc_dependency_1/ ; ls ; cd ..
cd kcc_dependency_2/ ; ls ; cd ..
cd kcc_dependency_3/ ; ls ; cd ..
# Exporting PATH here won't work on Jenkins. Must run directly from start script.
#echo "Old PATH: "$PATH
#export PATH=$(pwd)/kcc_dependency_1:$(pwd)/kcc_dependency_2:$(pwd)/kcc_dependency_3:$PATH
#echo "New PATH: "$PATH
