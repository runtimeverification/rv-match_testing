#!/bin/bash
rm -rf Open-Chargeport_kcc_test
mkdir Open-Chargeport_kcc_test
cd Open-Chargeport_kcc_test
git clone https://github.com/mstegen/Open-Chargeport.git
cd Open-Chargeport
git checkout 4fdffded66910fe04250e5dc19f3d89ede9bd17c
echo "Open-Chargeport build script is not completed."
