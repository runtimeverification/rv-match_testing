#!/bin/bash
bash merged.sh -u sets/selftest.ini
echo $'\n\nTest results: '
xmlfile="results/report.xml"
tempfile="results/temporary"
tempfile2="results/temporary2"
failelement='<error message="Failed.">'

if [ "`grep -A1 'make_fail.*make success' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"make fail\" test      : passes."
else
    echo "\"make fail\" test      : fails."
    echo "  - xml is supposed to produce string: $failelement when make fails."
fi
if [ ! "`grep -A1 'make_pass.*make success' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"make pass\" test      : passes."
else
    echo "\"make pass\" test      : fails."
    echo "  - xml is not supposed to produce string: $failelement when make passes."
fi
if [[ "`grep -A2 'make_log_tail.*make success' $xmlfile | tail -n 1`" == *"Umbrella"* ]] ; then
    echo "\"make log tail\" test  : passes."
else
    echo "\"make log tail\" test  : fails."
    echo "  - xml is supposed to embed kcc_make_out.txt when make fails."
fi

# Many kcc_config
tail -n +`grep -n -m 1 'many_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*1' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*2' $tempfile2 ; two="$?"
if [ "$one" == "0" ] && [ "$two" == "0" ] ; then
    echo "\"many_kcc_config\" test: passes."
else
    echo "\"many_kcc_config\" test: fails."
    echo "  - xml is supposed to contain both kcc_config results."
fi

# One kcc_config
tail -n +`grep -n -m 1 'one_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*1' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*2' $tempfile2 ; two="$?"
if [ "$one" == "0" ] && [ "$two" == "1" ] ; then
    echo "\"one_kcc_config\" test : passes."
else
    echo "\"one_kcc_config\" test : fails."
    echo "  - xml is supposed to contain one kcc_config result."
fi

# No kcc_config
tail -n +`grep -n -m 1 'no_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*1' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*2' $tempfile2 ; two="$?"
if [ "$one" == "1" ] && [ "$two" == "1" ] ; then
    echo "\"no_kcc_config\" test  : passes."
else
    echo "\"no_kcc_config\" test  : fails."
    echo "  - xml is supposed to contain no kcc_config results when no kcc_config is there."
fi

rm $tempfile
rm $tempfile2
