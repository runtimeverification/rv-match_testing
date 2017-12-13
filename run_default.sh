#!/bin/bash

bash run_set.sh sets/interesting.ini

#for x in tests/*/test.sh
#do
#    echo ==== $x started at $(date)
#    bash $x
#    echo ==== $x finished at $(date)
#done
#bash extract_output.sh

# k-bin-to-text kcc_config kcc_config.txt
# sed 's/<k>/\n<k>/' kcc_config.txt | tail -n1 >kcc_k_config.txt
