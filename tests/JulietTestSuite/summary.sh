#!/bin/bash
echo "                           Cases where kcc didn't find UB: $(wc -l < "nono.txt")"
echo "                                Cases which appear normal: $(wc -l < "noyes.txt")"
echo "            Strange cases UB only found in \"good\" version: $(wc -l < "yesno.txt")"
echo "Cases where kcc may have found an error in the test suite: $(wc -l < "yesyes.txt")"
echo "                           Cases where the test timed out: $(wc -l < "timeout.txt")"
echo "              Cases where the test had an issue being ran: $(wc -l < "strange.txt")"
#echo "===="
#cat stdout.txt
#echo "===="
#cat stderr.txt
#echo "==== ===="
#cat stdout_tool.txt
#echo "===="
#cat stderr_tool.txt
#echo "===="
