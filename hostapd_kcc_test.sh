rm -rf hostapd_kcc_test
mkdir hostapd_kcc_test
cd hostapd_kcc_test
STRTDIR=$(pwd)
git clone git://w1.fi/hostap.git
cd hostap
git checkout af872d9d88b1c868279983ef2c1b65ff81d7347b
cd hostapd
export CC=kcc
export CFLAGS="-std=gnu11 -frecover-all-errors"
cp defconfig .config
sed -i '/CONFIG_LIBNL32=y/s/^#//g' .config
sed -i '157iOBJS_c += ../src/utils/wpabuf.o' Makefile
make |& tee kcc_make_out.txt
cd $STRTDIR
#sed -i '/<pattern>/s/^#//g' file
#https://askubuntu.com/questions/617973/fatal-error-netlink-genl-genl-h-no-such-file-or-directory
