#!/bin/bash
bash merged.sh -u sets/selftest.ini
echo $'\n\nTest results: '
xmlfile="results/report.xml"
tempfile="results/temporary"
tempfile2="results/temporary2"
failelement='<error message="Failed.">'

if [ "`grep -A1 'make_fail.*make success' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"make fail\" test               : passes."
else
    echo "\"make fail\" test               : fails."
    echo "  - xml is supposed to produce string: $failelement when make fails."
fi
if [ ! "`grep -A1 'make_pass.*make success' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"make pass\" test               : passes."
else
    echo "\"make pass\" test               : fails."
    echo "  - xml is not supposed to produce string: $failelement when make passes."
fi
if [[ "`grep -A2 'make_log_tail.*make success' $xmlfile | tail -n 1`" == *"Umbrella"* ]] ; then
    echo "\"make log tail\" test           : passes."
else
    echo "\"make log tail\" test           : fails."
    echo "  - xml is supposed to embed kcc_make_out.txt when make fails."
fi

# Many kcc_config
tail -n +`grep -n -m 1 'many_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*1' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*2' $tempfile2 ; two="$?"
if [ "$one" == "0" ] && [ "$two" == "0" ] ; then
    echo "\"many_kcc_config\" test         : passes."
else
    echo "\"many_kcc_config\" test         : fails."
    echo "  - xml is supposed to contain both kcc_config results."
fi

# One kcc_config
tail -n +`grep -n -m 1 'one_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*1' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*2' $tempfile2 ; two="$?"
if [ "$one" == "0" ] && [ "$two" == "1" ] ; then
    echo "\"one_kcc_config\" test          : passes."
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
    echo "\"no_kcc_config\" test           : passes."
else
    echo "\"no_kcc_config\" test  : fails."
    echo "  - xml is supposed to contain no kcc_config results when no kcc_config is there."
fi

# Unit test single pass
if [ ! "`grep -A1 'unit_test_single_pass.*test1' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"unit test single pass\" test   : passes."
else
    echo "\"unit test single pass\" test   : fails."
    echo "  - xml is not supposed to produce string: $failelement when a unit test passes."
    echo "  - instead it gave "`grep -A1 'unit_test_single_pass.*test1' $xmlfile | tail -n 1`
fi

# Unit test single fail
if [ "`grep -A1 'unit_test_single_fail.*test1' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"unit test single fail\" test   : passes."
else
    echo "\"unit test single fail\" test   : fails."
    echo "  - xml is supposed to produce string: $failelement when a unit test fails."
    echo "  - instead it gave "`grep -A1 'unit_test_single_fail.*test1' $xmlfile | tail -n 1`
fi

# Unit test pass then fail
if [ ! "`grep -A1 'unit_test_pass_then_fail.*test1' $xmlfile | tail -n 1`" == "$failelement" ] && [ "`grep -A1 'unit_test_pass_then_fail.*test2' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"unit test pass then fail\" test: passes."
else
    echo "\"unit test pass then fail\" test: fails."
    echo "  - xml is supposed to produce string: $failelement iff that unit test fails."
fi

# Unit test k term
tail -n +`grep -n -m 1 'unit_test_k_term.*test1' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'pre k term sample' $tempfile2 ; one="$?"
grep -q 'post k term sample' $tempfile2 ; two="$?"
if [ "$one" == "1" ] && [ "$two" == "0" ] ; then
    echo "\"unit_test_k_term\" test        : passes."
else
    echo "\"unit_test_k_term\" test        : fails."
    echo "  - xml is supposed to contain characters after <k> term in config."
fi

# Unit test location term
tail -n +`grep -n -m 1 'unit_test_location_term.*test1' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'pre location term sample' $tempfile2 ; one="$?"
grep -q 'post location term sample' $tempfile2 ; two="$?"
if [ "$one" == "1" ] && [ "$two" == "0" ] ; then
    echo "\"unit_test_location_term\" test : passes."
else
    echo "\"unit_test_location_term\" test : fails."
    echo "  - xml is supposed to contain characters after <curr-program-loc> term in config."
fi

# Unit test log
tail -n +`grep -n -m 1 'unit_test_log.*test1' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'sample output log' $tempfile2 ; one="$?"
if [ "$one" == "0" ] ; then
    echo "\"unit_test_log\" test           : passes."
else
    echo "\"unit_test_log\" test           : fails."
    echo "  - xml is supposed to contain the tail of kcc_out_0.txt."
fi

rm $tempfile
rm $tempfile2
