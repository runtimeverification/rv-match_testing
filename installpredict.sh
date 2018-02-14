#!/bin/bash

echo "<install rv-predict>"
wget -q https://runtimeverification.com/predict/download/c?v=1.9
mv c\?v\=1.9 predict.jar
# uninstall "sudo dpkg -r rv-predict-c"
printf "


1
1
1
" > stdinfile.txt
cat stdinfile.txt | sudo java -jar predict.jar -console
echo "<uninstall rv-predict>"
