# This still needs work.
# I'm not sure how to properly build linux.
rm -rf linux_kcc_test
mkdir linux_kcc_test
cd linux_kcc_test
STRTDIR=$(pwd)
git clone https://github.com/torvalds/linux.git
cd linux
git checkout 4fbd8d194f06c8a3fd2af1ce560ddb31f7ec8323
make mrproper CC=kcc LD=kcc |& tee kcc_make_out.txt

