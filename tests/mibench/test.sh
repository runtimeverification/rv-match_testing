#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    git clone https://github.com/embecosm/mibench.git
    cd mibench/
    git checkout 0f3cbcf6b3d589a2b0753cfb9289ddf40b6b9ed8
}

_build() {
    cd mibench/
    top=$(pwd)
    out=$top/kcc_make_out.txt
    configure_success="0"
    _build_helper ; make_success="$?"
}

_build_helper() {

# These commands are purposely flattened and redundant to provide ease of direct access to customizing each as necessary. Most currently look the same because minimal effort was put into getting much of the project built. As more customized effort is put forth, the script is expected to become more detailed and differ for the sub-components.


# automotive: 4

dir="$top/automotive/basicmath/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/automotive/bitcount/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/automotive/qsort/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/automotive/susan/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1


# consumer: 5

dir="$top/consumer/jpeg/jpeg-6a/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/consumer/lame/lame3.70/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

#dir="$top/consumer/mad/mad-0.14.2b/"
#echo "$dir" >> $out
#cd "$dir"
#./configure && make |& tee -a $out || return 1

#dir="$top/consumer/tiff-v3.5.4/"
#echo "$dir" >> $out
#cd "$dir"
#./configure && make |& tee -a $out || return 1

dir="$top/consumer/typeset/lout-3.24/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1


# network: 2

dir="$top/network/dijkstra/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/network/patricia/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1


# office: 5

#dir="$top/office/ghostscript/src/"
#echo "$dir" >> $out
#cd "$dir"
#make |& tee -a $out || return 1

#dir="$top/office/ispell/"
#echo "$dir" >> $out
#cd "$dir"
#make |& tee -a $out || return 1

#dir="$top/office/rsynth/"
#echo "$dir" >> $out
#cd "$dir"
#./configure && make |& tee -a $out || return 1

#dir="$top/office/sphinx/"
#echo "$dir" >> $out
#cd "$dir"
#./configure && make |& tee -a $out || return 1

dir="$top/office/stringsearch/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1


# security: 4

dir="$top/security/blowfish/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

#dir="$top/security/pgp/src/"
#echo "$dir" >> $out
#cd "$dir"
#make linux |& tee -a $out || return 1

#dir="$top/security/rijndael/"
#echo "$dir" >> $out
#cd "$dir"
#make |& tee -a $out || return 1

dir="$top/security/sha/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1


# telecomm: 4

#dir="$top/telecomm/adpcm/src/"
#echo "$dir" >> $out
#cd "$dir"
#make |& tee -a $out || return 1

dir="$top/telecomm/CRC32/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/telecomm/FFT/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

dir="$top/telecomm/gsm/"
echo "$dir" >> $out
cd "$dir"
sed -i -e "s/gcc/$compiler/g" Makefile
make |& tee -a $out || return 1

return 0

}

_test() {
    :
}

init
