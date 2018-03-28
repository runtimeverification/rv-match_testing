#! /usr/bin/env bash

# Obtained from Chris Hathhorn
# March 28 2018
#   categorize.sh
# > fetch.sh
#   juliet.pl
#   runner.pl

set -x

echo "Downloading and unzipping Juliet v1.3..."
wget https://samate.nist.gov/SRD/testsuites/juliet/Juliet_Test_Suite_v1.3_for_C_Cpp.zip
unzip Juliet_Test_Suite_v1.3_for_C_Cpp.zip -d juliet
