#!/bin/bash
rm -rf cFE_kcc_test
mkdir cFE_kcc_test
cd cFE_kcc_test
STRTDIR=$(pwd)
if [[ ! -f cFE-6.5.0a-OSS-release.tar.gz ]]; then
  wget "https://sourceforge.net/projects/coreflightexec/files/cFE-6.5.0a-OSS-release.tar.gz"
fi
tar -xvzf cFE-6.5.0a-OSS-release.tar.gz
cd $STRTDIR/cFE-6.5.0a-OSS-release
echo "Building Nasa's cFE script is not complete."
