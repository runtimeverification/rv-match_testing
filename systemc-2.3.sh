#!/bin/bash
rm -rf systemc-2.3_kcc_test/
mkdir systemc-2.3_kcc_test/
cd systemc-2.3_kcc_test/
git clone https://github.com/systemc/systemc-2.3.git
cd systemc-2.3/
git checkout 686336b03ea17374024df0ae8272d7e22ba2692f
echo "systemc-2.3 script is not finished."
