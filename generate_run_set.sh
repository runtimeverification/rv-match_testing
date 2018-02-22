#!/bin/bash
allfile="sets/_generated_all.ini"
rm $allfile
touch $allfile
for x in tests/*/test.sh
do
    test_name=$(basename $(dirname $x))
    echo $test_name >> $allfile
done

untrackedfile="sets/_generated_untracked.ini"
temp="sets/.temp.ini"
rm $untrackedfile
comm -23 <(sort $allfile) <(sort sets/acceptance.ini) > $temp
comm -23 <(sort $temp) <(sort sets/regression.ini) > $untrackedfile
rm $temp
