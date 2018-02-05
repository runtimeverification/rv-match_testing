#!/bin/bash
currentdir=$(pwd)
kccsource="/var/lib/jenkins/jobs/rv-match-master-copy/workspace"
cd $kccsource
kccgithash=$(git rev-parse HEAD)
cd $currentdir
rm -r kcc_dependency_1/
rm -r kcc_dependency_2/
rm -r kcc_dependency_3/
cp -r $kccsource/c-semantics/dist ./kcc_dependency_1/
cp -r $kccsource/errors/rv-error/bin ./kcc_dependency_2/
mkdir kcc_dependency_3/
cp -r $kccsource/k/k-distribution/target/release/k/bin ./kcc_dependency_3/bin
cp -r $kccsource/k/k-distribution/target/release/k/lib ./kcc_dependency_3/lib
cd $kccsource
kccgithash2=$(git rev-parse HEAD)
echo "rv-match git hash before copying kcc: "$kccgithash
echo "rv-match git hash after  copying kcc: "$kccgithash2
if [[ $kccgithash != $kccgithash2 ]] ; then
    echo "Warning: git hash changed during copy."
else
    echo "Git hash remained the same during copy."
fi
echo "Found by running \"git rev-parse HEAD\" in \"$kccsource\"."
#echo k-bin-to-text
#if [[ $(k-bin-to-text)  == "Error: Could not find or load main class org.kframework.main.BinaryToText" ]] ; then
#    echo "Starting kserver..."
#    kserver &
#else
#    echo "Looks like kserver was already started:"
#    echo $(k-bin-to-text)
#fi

cd $currentdir
cd kcc_dependency_1/ ; ls ; cd ..
cd kcc_dependency_2/ ; ls ; cd ..
cd kcc_dependency_3/ ; ls ; cd ..
# Exporting PATH here won't work on Jenkins. Must run directly from start script.
#echo "Old PATH: "$PATH
#export PATH=$(pwd)/kcc_dependency_1:$(pwd)/kcc_dependency_2:$(pwd)/kcc_dependency_3:$PATH
#echo "New PATH: "$PATH
