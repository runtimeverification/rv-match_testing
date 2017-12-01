#https://github.com/runtimeverification/rv-match/issues/590
rm -rf curve25519_kcc_test/
mkdir curve25519_kcc_test/
cd curve25519_kcc_test/
STRTDIR=$(pwd)
git clone https://github.com/msotoodeh/curve25519.git
cd curve25519/
git checkout 85dcab1300ff1b196042839de9c8bbea26329537

