#!/bin/bash 
for x in $(ls *.sh | grep -v $(basename $0) | sort)
do
    echo ==== $x
    # bash $x
done
