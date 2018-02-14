#!/bin/bash
# uninstall "sudo dpkg -r rv-predict-c"
echo "<install rv-predict>"
wget -q https://runtimeverification.com/predict/download/c?v=1.9
mv c\?v\=1.9 predict.jar
printf "


1
1
1
" > stdinfile.txt
cat stdinfile.txt | sudo java -jar predict.jar -console ; rm stdinfile.txt
echo "</install rv-predict>"
