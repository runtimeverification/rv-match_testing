#!/bin/bash
for x in $(ls *_kcc_test.sh | sort)
do
    echo ==== $x started at $(date)
    #bash $x
    echo ==== $x finished at $(date)
done
bash extract_output.sh

# k-bin-to-text kcc_config kcc_config.txt
# sed 's/<k>/\n<k>/' kcc_config.txt | tail -n1 >kcc_k_config.txt
