#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh "$@"

_dependencies() {
    :
}

_download() {
    wget http://apache.mirrors.tds.net/tomcat/tomcat-9/v9.0.6/src/apache-tomcat-9.0.6-src.tar.gz
    tar -xzf apache-tomcat-9.0.6-src.tar.gz
    rm apache-tomcat-9.0.6-src.tar.gz
}

_build() {
    # Do not place this on regression sets! It does not use a custom compiler yet.
    cd apache-tomcat-9.0.6-src/
    cp build.properties.default build.properties
    names[0]="replace basepath" ; sed -i "s|^.*base.path=.*$|base.path=$(pwd)/build-libraries/|" build.properties |& tee rv_build_0.txt ; results[0]="$?" ; postup 0
    names[1]="ant" ; ant |& tee rv_build_1.txt ; results[1]="$?" ; postup 1
}

_test() {
    :
}

init
