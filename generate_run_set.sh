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
temp1="sets/.temp1.ini"
temp2="sets/.temp2.ini"
rm $untrackedfile
comm -23 <(sort $allfile) <(sort sets/acceptance.ini) > $temp1
comm -23 <(sort $temp1) <(sort sets/regression.ini) > $temp2
comm -23 <(sort $temp2) <(sort sets/regression_extended.ini) > $temp1
comm -23 <(sort $temp1) <(sort sets/acceptance_extended.ini) > $temp2
comm -23 <(sort $temp2) <(sort sets/gcc_only.ini) > $untrackedfile
rm $temp1
rm $temp2
