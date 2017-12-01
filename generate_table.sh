# To activate ssh key: git remote set-url origin git@github.com:TimJSwan89/rv-match_testing.wiki.git
tests_dir=$(pwd)
git clone https://github.com/TimJSwan89/rv-match_testing.wiki.git
cd rv-match_testing.wiki
git pull
#Old directory structure:
#echo "| $test_name | wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/${test_name}_kcc_test.sh && bash ${test_name}_kcc_test.sh |" >> Auto-Generated-Table.md

#New directory structure:
#echo "| $test_name | wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/tests/$test_name/test.sh -O ${test_name}_kcc_test.sh && bash ${test_name}_kcc_test.sh |" >> Auto-Generated-Table.md
read -s -p "Enter GitHub Password: " password

# Do not delete this line.
echo "This is an auto generated wiki." > Auto-Generated-Table.md

# Table showing configure and make success.
echo "  " >> Auto-Generated-Table.md
echo "| project | configure | make | open issues | closed issues | " >> Auto-Generated-Table.md
echo "| --- | --- | --- | --- | --- | " >> Auto-Generated-Table.md
for file_path in $(ls $tests_dir/*_kcc_test.sh | sort)
do
    script_name=$(basename $file_path)
    test_name=${script_name%_kcc_test.sh}
    folder_name=$test_name"_kcc_test"
    
    # Get configure results
    configure_result=":grey_question:"
    configure_result_path=$tests_dir/$folder_name/kcc_compile_out/kcc_configure_success.ini
    echo $configure_result_path
    echo -e $configure_result_path
    if [[ -e $configure_result_path ]] ; then
        if [[ "$(head -n 1 $configure_result_path)" == 0 ]] ; then
            configure_result=":white_check_mark:"
        else
            configure_result=":x:"
        fi
        echo "Test start"
        echo "$(head -n 1 $configure_result_path)"
        echo "Test end"
    fi

    # Get make results
    make_result=":grey_question:"
    make_result_path=$tests_dir/$folder_name/kcc_compile_out/kcc_make_success.ini
    echo $make_result_path
    echo -e $make_result_path
    if [[ -e $make_result_path ]] ; then
        if [[ "$(head -n 1 $make_result_path)" == 0 ]] ; then
            make_result=":white_check_mark:"
        else
            make_result=":x:"
        fi
    fi
    
    # Get issue {link, number}s in format: [number](link)
    echo "https://api.github.com/search/issues?q=repo:runtimeverification/rv-match+in:title+state:open+$test_name"
    open_issues=$(curl -u "TimJSwan89:$password" "https://api.github.com/search/issues?q=repo:runtimeverification/rv-match+in:title+state:open+$test_name" | jq '[.items[] | {html_url: .html_url, state: .state, number: .number, title: .title}]' | jq -r ".[] | select(.title | contains(\"$test_name\")) | select(.state | contains(\"open\")) | @text \"[\\(.number)](\\(.html_url))\"" | tr '\n' ' ')
    closed_issues=$(curl -u "TimJSwan89:$password" "https://api.github.com/search/issues?q=repo:runtimeverification/rv-match+in:title+state:closed+$test_name" | jq '[.items[] | {html_url: .html_url, state: .state, number: .number, title: .title}]' | jq -r ".[] | select(.title | contains(\"$test_name\")) | select(.state | contains(\"closed\")) | @text \"[\\(.number)](\\(.html_url))\"" | tr '\n' ' ')
    echo "| $test_name | $configure_result | $make_result | $open_issues | $closed_issues |" >> Auto-Generated-Table.md
done
#rm rv-match_issues.json

# Table for single command run scripts.
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
