#!/bin/bash
rm -r kcc_dependency_1/
rm -r kcc_dependency_2/
rm -r kcc_dependency_3/
cp -r /var/lib/jenkins/jobs/rv-match-master/workspace/c-semantics/dist ./kcc_dependency_1/
cp -r /var/lib/jenkins/jobs/rv-match-master/workspace/errors/rv-error/bin ./kcc_dependency_2/
cp -r /var/lib/jenkins/jobs/rv-match-master/workspace/k/k-distribution/target/release/k/bin ./kcc_dependency_3/
cd kcc_dependency_1/ ; ls ; cd ..
cd kcc_dependency_2/ ; ls ; cd ..
cd kcc_dependency_3/ ; ls ; cd ..

# Exporting PATH here won't work on Jenkins. Must run directly from start script.
#echo "Old PATH: "$PATH
#export PATH=$(pwd)/kcc_dependency_1:$(pwd)/kcc_dependency_2:$(pwd)/kcc_dependency_3:$PATH
#echo "New PATH: "$PATH
