bash copykcc.sh
export PATH=$(pwd)/kcc_dependency_1:$(pwd)/kcc_dependency_2:$(pwd)/kcc_dependency_3:$PATH
which kcc
kcc --version
kcc -version
echo "PATH variable contents: "$PATH
chmod 777 results/regression.xml
ls -la results/
bash lxccopy_regression.sh
#bash run_regression_set.sh sets/regression.ini
