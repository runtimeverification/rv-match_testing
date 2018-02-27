#!/bin/bash
returnvalue=0
tempfile="results/temporary"
tempfile2="results/temporary2"
tempfile3="results/temporary3"
failelement='<error message="Failed.">'
similarity() {

# Regression xml similarity test
xmlfile="results/regression.xml"
samplefile="selftest/regression_sample.xml"
cp $xmlfile $tempfile
cp $samplefile $tempfile2
rightTypes="1"
similar="0"
while [ "$(grep "<testcase classname=" $tempfile)" ] || [ "$(grep "<testcase classname=" $tempfile2)" ] && [ "$similar" == "0" ] ;
do
    rightTypes="0"
    tail -n +`grep -n -m 1 '<testcase classname=' $tempfile |cut -f1 -d:` $tempfile > $tempfile3
    one="$(head -n 1 $tempfile3)"
    one=${one%time*}
    tail -n +2 "$tempfile3" > $tempfile
    tail -n +`grep -n -m 1 '<testcase classname=' $tempfile2 |cut -f1 -d:` $tempfile2 > $tempfile3
    two="$(head -n 1 $tempfile3)"
    two=${two%time*}
    tail -n +2 "$tempfile3" > $tempfile2
    if [ ! "$one" == "$two" ] ; then
        similar="1"
    fi
done
if [ "$rightTypes" == "0" ] && [ $similar == "0" ] ; then
    echo "\"regression similarity\" test   : passes."
    rm $xmlfile
else
    echo "\"regression similarity\" test   : fails." ; returnvalue=1
    echo "  - the xml is supposed to be similar in structure to the past sample."
    if [ ! "$rightTypes" == "0" ] ; then
        echo "  - the xml files were not formatted properly."
    fi
    if [ ! "$similar" == "0" ] ; then
        echo "  - xml is not similar to past regression structure."
    fi
    echo "  - to update samples, run again with \"r\"."
fi
# Acceptance xml similarity test (similar code to regression test)
xmlfile="results/acceptance.xml"
samplefile="selftest/acceptance_sample.xml"
cp $xmlfile $tempfile
cp $samplefile $tempfile2
rightTypes="1"
similar="0"
while [ "$(grep "<testcase classname=" $tempfile)" ] || [ "$(grep "<testcase classname=" $tempfile2)" ] && [ "$similar" == "0" ] ;
do
    rightTypes="0"
    tail -n +`grep -n -m 1 '<testcase classname=' $tempfile |cut -f1 -d:` $tempfile > $tempfile3
    one="$(head -n 1 $tempfile3)"
    one=${one%time*}
    tail -n +2 "$tempfile3" > $tempfile
    tail -n +`grep -n -m 1 '<testcase classname=' $tempfile2 |cut -f1 -d:` $tempfile2 > $tempfile3
    two="$(head -n 1 $tempfile3)"
    two=${two%time*}
    tail -n +2 "$tempfile3" > $tempfile2
    if [ ! "$one" == "$two" ] ; then
        similar="1"
    fi
done
if [ "$rightTypes" == "0" ] && [ $similar == "0" ] ; then
    echo "\"acceptance similarity\" test   : passes."
    rm $xmlfile
else
    echo "\"acceptance similarity\" test   : fails." ; returnvalue=1
    echo "  - the xml is supposed to be similar in structure to the past sample."
    if [ ! "$rightTypes" == "0" ] ; then
        echo "  - the xml files were not formatted properly."
    fi
    if [ ! "$similar" == "0" ] ; then
        echo "  - xml is not similar to past regression structure."
    fi
    echo "  - to update samples, run again with \"r\"."
fi

}

if [ "$1" == "r" ] || [ "$1" == "-r" ] ; then
    if [ -e results/regression.xml ] ; then
        cp results/regression.xml selftest/regression_sample.xml
        echo "regression sample updated"
    fi
    if [ -e results/acceptance.xml ] ; then
        cp results/acceptance.xml selftest/acceptance_sample.xml
        echo "acceptance sample updated"
    fi
    if [ ! -e results/acceptance.xml ] && [ ! -e results/regression.xml ] ; then
        echo "No new updates detected."
        exit 0
    fi
    echo "Ensuring that the new samples match against the current project..."
    bash merged.sh -ur selftest &> /dev/null
    bash merged.sh -ua selftest &> /dev/null
    similarity
    exit 0
fi
echo "Testing the rv-match_testing project, especially for expected xml format."
echo -ne '[                     ](0%  )\r'
bash merged.sh -ut selftest #&> /dev/null
echo -ne '[#######              ](33% )\r'
bash merged.sh -ur selftest #&> /dev/null
echo -ne '[##############       ](66% )\r'
bash merged.sh -ua selftest #&> /dev/null
echo -ne '[#####################](100%)\r'
echo $'\n\nTest results: '
xmlfile="results/report.xml"
which date &> /dev/null ; date_works="$?"
if [ "$date_works" == "0" ] ; then
    echo "\"date command\" test            : passes."
else
    echo "\"date command\" test            : fails." ; returnvalue=1
    echo "  - \"which date\" failed:"
    which date
fi
which fuser &> /dev/null ; fuser_works="$?"
if [ "$fuser_works" == "0" ] ; then
    echo "\"fuser command\" test           : passes."
else
    echo "\"fuser command\" test           : fails." ; returnvalue=1
    echo "  - \"which fuser\" failed:"
    which fuser
fi
which bc &> /dev/null ; bc_works="$?"
if [ "$bc_works" == "0" ] ; then
    echo "\"bc command\" test              : passes."
else
    echo "\"bc command\" test              : fails." ; returnvalue=1
    echo "  - \"which bc\" failed:"
    which bc
fi
ping -c 1 www.google.com &> /dev/null ; network_works="$?"
echo -ne '\n'
if [ "$network_works" == "0" ] ; then
    echo "\"network\" test                 : passes."
else
    echo "\"network\" test                 : fails." ; returnvalue=1
    echo "  - ping to google.com failed."
fi
if [ "`grep -A1 'make_fail.*make success' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"make fail\" test               : passes."
else
    echo "\"make fail\" test               : fails." ; returnvalue=1
    echo "  - xml is supposed to produce string: $failelement when make fails."
fi
if [ ! "`grep -A1 'make_pass.*make success' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"make pass\" test               : passes."
else
    echo "\"make pass\" test               : fails." ; returnvalue=1
    echo "  - xml is not supposed to produce string: $failelement when make passes."
fi
if [[ "`grep -A5 'make_log_tail.*make success' $xmlfile | tail -n 1`" == *"Umbrella"* ]] ; then
    echo "\"make log tail\" test           : passes."
else
    echo "\"make log tail\" test           : fails." ; returnvalue=1
    echo "  - xml is supposed to embed kcc_build_1.txt when make fails."
fi

# Non-empty times
grep 'time=""' $xmlfile &> /dev/null ; nonemptytest="$?"
if [ ! "$nonemptytest" == "0" ] ; then
    echo "\"non-empty time\" test          : passes."
else
    echo "\"non-empty time\" test           : fails." ; returnvalue=1
    echo "  - xml should not contain this string: 'time=\"\"', but it does:"
    grep 'time=""' $xmlfile
fi

# Timeout pass
if [[ ! "`grep -A1 'timeout_pass.*make success' $xmlfile | tail -n 1`" == "$failelement" ]] ; then
    echo "\"timeout pass\" test            : passes."
else
    echo "\"timeout pass\" test            : fails." ; returnvalue=1
    echo "  - a test finished successfully on time should result in a pass."
fi

# Timeout fail
if [[ "`grep -A1 'timeout_fail.*make success' $xmlfile | tail -n 1`" == "$failelement" ]] ; then
    echo "\"timeout fail\" test            : passes."
else
    echo "\"timeout fail\" test            : fails." ; returnvalue=1
    echo "  - a test not finishing in time should result in a fail."
fi

# Many kcc_config
tail -n +`grep -n -m 1 'many_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*-0' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*-1' $tempfile2 ; two="$?"
if [ "$one" == "0" ] && [ "$two" == "0" ] ; then
    echo "\"many_kcc_config\" test         : passes."
else
    echo "\"many_kcc_config\" test         : fails." ; returnvalue=1
    echo "  - xml is supposed to contain both kcc_config results."
fi

# One kcc_config
tail -n +`grep -n -m 1 'one_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*-0' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*-1' $tempfile2 ; two="$?"
if [ "$one" == "0" ] && [ "$two" == "1" ] ; then
    echo "\"one_kcc_config\" test          : passes."
else
    echo "\"one_kcc_config\" test : fails." ; returnvalue=1
    echo "  - xml is supposed to contain one kcc_config result."
fi

# No kcc_config
tail -n +`grep -n -m 1 'no_kcc_config.*make success' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'Found a kcc_config number.*-0' $tempfile2 ; one="$?"
grep -q 'Found a kcc_config number.*-1' $tempfile2 ; two="$?"
if [ "$one" == "1" ] && [ "$two" == "1" ] ; then
    echo "\"no_kcc_config\" test           : passes."
else
    echo "\"no_kcc_config\" test  : fails." ; returnvalue=1
    echo "  - xml is supposed to contain no kcc_config results when no kcc_config is there."
fi

# Unit test single pass
if [ ! "`grep -A1 'unit_test_single_pass.*test1' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"unit test single pass\" test   : passes."
else
    echo "\"unit test single pass\" test   : fails." ; returnvalue=1
    echo "  - xml is not supposed to produce string: $failelement when a unit test passes."
    echo "  - instead it gave "`grep -A1 'unit_test_single_pass.*test1' $xmlfile | tail -n 1`
fi

# Unit test single fail
if [ "`grep -A1 'unit_test_single_fail.*test1' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"unit test single fail\" test   : passes."
else
    echo "\"unit test single fail\" test   : fails." ; returnvalue=1
    echo "  - xml is supposed to produce string: $failelement when a unit test fails."
    echo "  - instead it gave "`grep -A1 'unit_test_single_fail.*test1' $xmlfile | tail -n 1`
fi

# Unit test pass then fail
if [ ! "`grep -A1 'unit_test_pass_then_fail.*test1' $xmlfile | tail -n 1`" == "$failelement" ] && [ "`grep -A1 'unit_test_pass_then_fail.*test2' $xmlfile | tail -n 1`" == "$failelement" ] ; then
    echo "\"unit test pass then fail\" test: passes."
else
    echo "\"unit test pass then fail\" test: fails." ; returnvalue=1
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
    echo "\"unit_test_k_term\" test        : fails." ; returnvalue=1
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
    echo "\"unit_test_location_term\" test : fails." ; returnvalue=1
    echo "  - xml is supposed to contain characters after <curr-program-loc> term in config."
fi

# Unit test log
tail -n +`grep -n -m 1 'unit_test_log.*test1' $xmlfile |cut -f1 -d:` $xmlfile > $tempfile
head -n `grep -n -m 1 '</testcase>' $tempfile |cut -f1 -d:` $tempfile > $tempfile2
grep -q 'sample output log' $tempfile2 ; one="$?"
if [ "$one" == "0" ] ; then
    echo "\"unit_test_log\" test           : passes."
else
    echo "\"unit_test_log\" test           : fails." ; returnvalue=1
    echo "  - xml is supposed to contain the tail of kcc_out_0.txt."
fi

similarity

# k-bin-to-text test
kbinin="selftest/k-bin-to-text_runs/kcc_config"
kbinout="selftest/k-bin-to-text_runs/kcc_config.txt"
rm $kbinout 2> /dev/null
k-bin-to-text $kbinin $kbinout 2> /dev/null ; one="$?"
if [ "$one" == "0" ] ; then
    [ -e $kbinout ] && grep -q "generatedTop" $kbinout ; two="$?"
    if [ "$two" == "0" ] ; then
        echo "\"k-bin-to-text\" test           : passes."
    else
        echo "\"k-bin-to-text\" test           : fails." ; returnvalue=1
        echo "  - command succeeded but generated file does exist or does not contain substring \"generatedTop\"."
    fi
else
    if [ "$one" == "1" ] ; then
        echo "\"k-bin-to-text\" test           : fails." ; returnvalue=1
        echo "  - command recognized but returned 1 so you may first need to run \"kserver &\"."
    else
        echo "\"k-bin-to-text\" test           : fails." ; returnvalue=1
        echo "  - command returned ""$one."
    fi
fi

rm $tempfile
rm $tempfile2
rm $tempfile3

rm "results/report.xml"
#rm "results/acceptance.xml"
#rm "results/regression.xml"

exit $returnvalue
