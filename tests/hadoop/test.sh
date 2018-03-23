#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    #* Oracle JDK 1.8 (preferred)
    #$ sudo apt-get purge openjdk*
    #$ sudo apt-get install software-properties-common
    #$ sudo add-apt-repository ppa:webupd8team/java
    #$ sudo apt-get update
    #$ sudo apt-get install oracle-java8-installer
    #* Maven
    #$ sudo apt-get -y install maven
    #* Native libraries
    #$ sudo apt-get -y install build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev
    #* ProtocolBuffer 2.5.0 (required)
    #$ sudo apt-get -y install protobuf-compiler
}

_download() {
    wget http://apache.mirrors.pair.com/hadoop/common/hadoop-3.0.0/hadoop-3.0.0-src.tar.gz
    tar -xzf hadoop-3.0.0-src.tar.gz
    rm hadoop-3.0.0-src.tar.gz
}

_build() {
    cd hadoop-3.0.0-src/
    names[0]="mvn compile" ; mvn compile |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
}

_test() {
    :
}

init
