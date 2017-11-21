#!/bin/bash 
DIR=$(dirname $0)
for x in $(ls $DIR/*.sh | sort)
do
    if [ "$x" != "$DIR/$0" ]
    then
        echo ==== $x
        bash $x
    fi
done
