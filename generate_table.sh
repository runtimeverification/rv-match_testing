# To activate ssh key: git remote set-url origin git@github.com:TimJSwan89/rv-match_testing.wiki.git
tests_dir=$(pwd)
git clone https://github.com/TimJSwan89/rv-match_testing.wiki.git
cd rv-match_testing.wiki
git pull
#Old directory structure:
#echo "| $test_name | wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/${test_name}_kcc_test.sh && bash ${test_name}_kcc_test.sh |" >> Auto-Generated-Table.md

#New directory structure:
#echo "| $test_name | wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/tests/$test_name/test.sh -O ${test_name}_kcc_test.sh && bash ${test_name}_kcc_test.sh |" >> Auto-Generated-Table.md


echo "This wiki page was automatically generated.  " > Auto-Generated-Table.md
echo "  " >> Auto-Generated-Table.md
echo "| project | standalone script |  " >> Auto-Generated-Table.md
echo "| --- | --- |  " >> Auto-Generated-Table.md
for file_path in $(ls $tests_dir/*_kcc_test.sh | sort)
do
    script_name=$(basename $file_path)
    test_name=${script_name%_kcc_test.sh}
    echo "| $test_name | wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/${test_name}_kcc_test.sh && bash ${test_name}_kcc_test.sh |" >> Auto-Generated-Table.md
done
git add Auto-Generated-Table.md
git commit -am "Auto generated commit."
git push
