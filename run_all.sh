#! /bin/bash                                                                    
DIR=$(dirname $0)
for x in $DIR/*.sh
do
        if [ "$x" != "$DIR/$0" ]
        then
            sh $x
        fi
done
