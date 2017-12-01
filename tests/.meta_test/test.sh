#!/bin/bash
[ ! -f prepare.sh ] && wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/prepare.sh
base_dir=$(pwd); cd $(dirname $BASH_SOURCE); . $base_dir/prepare.sh

_download() {
    touch insert_downloads_here
}
init

echo "test_name=$test_name"
echo "test_dir=$test_dir"
echo "build_dir=$build_dir"
echo "log_dir=$log_dir"
