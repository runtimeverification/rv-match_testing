#!/bin/bash 
for x in $(ls *.sh | grep -v $(basename $0) | sort)
do
    echo ==== $x started at $(date)
    bash $x
done

# k-bin-to-text kcc_config kcc_config.txt
# sed 's/<k>/\n<k>/' kcc_config.txt | tail -n1 >kcc_k_config.txt
