#!/bin/bash

# Extract out undefined behavior and log it back into a file

#echo "1: $1"
#echo "2: $2"

temp="_temporaryfile.log"

rm -f $temp
touch $temp

# Algorithm:
# 1. Search for a standard string: startline
# 2. From startline, search down for empty line endline
# 3. From startline, search up for first non-empty non-indented line upline
# 4. Repeat for next line after endline

std[0]="Undefined behavior"
std[1]="Unspecified value or behavior"
std[2]="Implementation defined behavior"
std[3]="Conditionally-supported behavior"
std[4]="Ill-formed program"
std[5]="Behavior underspecified by standard"
std[6]="Constraint violation"
std[7]="Syntax error"

for t in "${!std[@]}"
do
    cnt[$t]=0
done
for t in "${!std[@]}"
do
    while read -r line ; do
        # Search up & save line number
        up=`head -n+$line $1 | tac | grep -m 1 -ne '^[^[:space:]]' | grep -Eo '^[^:]+'`
        
        # Search down & save line number
        down=`tail -n+$line $1 | grep -m 1 -ne '^$' | grep -Eo '^[^:]+'`
        
        let top="$line - $up + 1"
        let height="$up + $down - 2"
        echo "=========================" >> $temp
        tail -n+$top $1 | head -n$height >> $temp
        let cnt[$t]="${cnt[$t]} + 1"
    done < <(grep -n "${std[$t]}" $1 | grep -Eo '^[^:]+')
done
for t in "${!std[@]}"
do
    if [ ! "${cnt[$t]}" == "0" ] ; then
        echo "${std[$t]}: ${cnt[$t]}" >> $2
    fi
done
cat $temp >> $2
rm -f $temp
