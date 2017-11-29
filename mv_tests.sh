#!/bin/bash

for fname in *_kcc_test.sh; do
    mkdir -p tests/${fname%_kcc_test.sh}
    mv $fname tests/${fname%_kcc_test.sh}/test.sh
done