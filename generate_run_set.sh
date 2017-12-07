#!/bin/bash
allfile="sets/_generated_all.ini"
rm $allfile
touch $allfile
for x in tests/*/test.sh
do
    test_name=$(basename $(dirname $x))
    echo $test_name >> $allfile
done
