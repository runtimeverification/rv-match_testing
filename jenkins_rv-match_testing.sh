sh copykcc.sh
export PATH=$(pwd)/kcc_dependency_1:$(pwd)/kcc_dependency_2:$(pwd)/kcc_dependency_3:$PATH
echo "PATH variable contents: "$PATH
echo "kcc --version"
kcc --version
echo "kcc -version"
kcc -version
echo "which kcc"
which kcc
bash lxccopy.sh
