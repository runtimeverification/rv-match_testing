#!/bin/bash
for x in tests/*/test.sh
do
    echo ==== $x
    p=$(basename $(dirname $x))
    newf="tests/$p/build.sh"
    touch $newf
    awk "/_build\(\) {/{flag=1;next}/}/{flag=0}flag" $x | sed "s/^[ \t]*//" > $newf
    echo $newf
    git rm -f $newf
    rm $newf
done
