#!/bin/bash
# https://github.com/embecosm/mibench.git
# 0f3cbcf6b3d589a2b0753cfb9289ddf40b6b9ed8

_helper() {
    if [ -z "$path" ] ; then path="$name" ; fi
    cd "$top/$folder/$path/"
    names[$mii]="$name Makefile alteration"
    sed -i -e "s/gcc/kcc/g" Makefile |& tee rv_build_$mii.txt ; results[$mii]="$?" ; postup $mii
    let "mii += 1"
    if [ "$configure_flag" == "0" ] ; then
        names[$mii]="$name configure"
        CC=kcc LD=kcc ./configure |& tee rv_build_$mii.txt ; results[$mii]="$?" ; postup $mii
        let "mii += 1"
    fi
    names[$mii]="$name make"
    make -j`nproc` $make_arg |& tee rv_build_$mii.txt ; results[$mii]="$?" ; postup $mii
    
    path=""
    make_arg=""
    let "mii += 1"
    configure_flag="1"
}

top=$(pwd)
path=""
make_arg=""
mii=1
configure_flag="1"

folder="automotive" # automotive: 4
name="basicmath" ; _helper
name="bitcount"  ; _helper
name="qsort"     ; _helper
name="susan"     ; _helper

folder="consumer"   # consumer: 5
path="jpeg/jpeg-6a"      ; name="jpeg" ; _helper
path="lame/lame3.70"     ; name="lame" ; _helper
#path="mad/mad-0.14.2b"   ; name="mad"  ; configure_flag="0" ; _helper
#path="tiff-v3.5.4"       ; name="tiff" ; configure_flag="0" ; _helper
path="typeset/lout-3.24" ; name="typeset" ; _helper

folder="network" # network: 2
name="dijkstra"  ; _helper
name="patricia"  ; _helper

folder="office" # office: 5
#path="ghostscript/src" ; name="ghostscript" ; _helper
#name="ispell" ; _helper
#name="rsynth" ; configure_flag="0" ; _helper
#name="sphinx" ; configure_flag="0" ; _helper
name="stringsearch" ; _helper

folder="security" # security: 4
name="blowfish" ; _helper
#path="pgp/src" ; name="pgp" ; make_arg="linux" ; _helper
#name="rijndael" ; _helper
name="sha" ; _helper

folder="telecomm" # telecomm: 4
#path="adpcm/src" ; name="adpcm" ; _helper
name="CRC32" ; _helper
name="FFT" ; _helper
name="gsm" ; _helper
