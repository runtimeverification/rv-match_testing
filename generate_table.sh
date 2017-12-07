# To activate ssh key: git remote set-url origin git@github.com:TimJSwan89/rv-match_testing.wiki.git
tests_dir="$(pwd)/tests/"
git clone https://github.com/TimJSwan89/rv-match_testing.wiki.git
cd rv-match_testing.wiki
git pull
tablefile="Auto-Generated-Table-2.0.md"
read -s -p "Enter GitHub Password: " password

# Do not delete this line.
echo "This is an auto generated wiki." > $tablefile

# Table showing configure and make success.
echo "  " >> $tablefile
echo "| project | conf gcc | make gcc | test gcc | conf kcc | make kcc | kcc conf | test kcc | open issue | clsd issue | " >> $tablefile
echo "| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |" >> $tablefile
get_successes_for_compiler_and_buildstage() {
    # Gets either configure or make results from either gcc or kcc
    result=$string_non_exist
    result_path=$tests_dir/$test_name/$compiler/log/latest/${buildstage}_success.ini
    echo $result_path
    echo -e $result_path
    if [[ -e $result_path ]] ; then
        if [[ "$(head -n 1 $result_path)" == 0 ]] ; then
            result=$string_success
        else
            result=$string_fail
        fi
        echo "Test start"
        echo "$(head -n 1 $result_path)"
        echo "Test end"
    fi
}
for file_path in $(ls $tests_dir/*/test.sh | sort)
do
    test_name=$(basename $(dirname $file_path))
    
    string_non_exist=":grey_question:"
    string_success=":white_check_mark:"
    string_fail=":x:"
    compiler="gcc" ; buildstage="configure"
    get_successes_for_compiler_and_buildstage && gcc_configure_result=$result
    compiler="gcc" ; buildstage="make"
    get_successes_for_compiler_and_buildstage && gcc_make_result=$result
    compiler="gcc" ; buildstage="test"
    get_successes_for_compiler_and_buildstage && gcc_test_result=$result
    compiler="kcc" ; buildstage="configure"
    get_successes_for_compiler_and_buildstage && kcc_configure_result=$result
    compiler="kcc" ; buildstage="make"
    get_successes_for_compiler_and_buildstage && kcc_make_result=$result
    compiler="kcc" ; buildstage="test"
    get_successes_for_compiler_and_buildstage && kcc_test_result=$result
    
    string_success=" "
    string_fail=":exclamation:"
    compiler="kcc" ; buildstage="no_kcc_config_generated"
    get_successes_for_compiler_and_buildstage && kcc_config_result=$result


    #(rem=$(curl -u "TimJSwan89:$password" "https://api.github.com/rate_limit" | jq '.resources.search.remaining')) ; echo $rem" should work"
    while rem=$(curl -u "TimJSwan89:$password" "https://api.github.com/rate_limit" | jq '.resources.search.remaining') && [[ $rem -le 2 ]]
    do
        echo $rem" calls remaining"
        #reset=$(curl -u "TimJSwan89:$password" "https://api.github.com/rate_limit" | jq '.resources.search.reset')
        #now=$(date +%s)
        #sleeptime=$(($reset - $now + 1))
        sleeptime=1
        echo "waiting for "$sleeptime" seconds..."
        sleep $sleeptime
    done
    echo $rem" calls remaining"
    # Get issue {link, number}s in format: [number](link)
    echo "https://api.github.com/search/issues?q=repo:runtimeverification/rv-match+in:title+state:open+\"$test_name\""
    open_issues=$(curl -u "TimJSwan89:$password" "https://api.github.com/search/issues?q=repo:runtimeverification/rv-match+in:title+state:open+\"$test_name\"" | jq '[.items[] | {html_url: .html_url, state: .state, number: .number, title: .title}]' | jq -r ".[] | select(.title | contains(\"$test_name\")) | select(.state | contains(\"open\")) | @text \"[\\(.number)](\\(.html_url))\"" | tr '\n' ' ')
    closed_issues=$(curl -u "TimJSwan89:$password" "https://api.github.com/search/issues?q=repo:runtimeverification/rv-match+in:title+state:closed+\"$test_name\"" | jq '[.items[] | {html_url: .html_url, state: .state, number: .number, title: .title}]' | jq -r ".[] | select(.title | contains(\"$test_name\")) | select(.state | contains(\"closed\")) | @text \"[\\(.number)](\\(.html_url))\"" | tr '\n' ' ')
    echo "| $test_name | $gcc_configure_result | $gcc_make_result | $gcc_test_result | $kcc_configure_result | $kcc_make_result | $kcc_config_result | $kcc_test_result | $open_issues | $closed_issues |" >> $tablefile
done
#rm rv-match_issues.json

# Table for single command run scripts.
echo "  " >> $tablefile
echo "| project | standalone script |  " >> $tablefile
echo "| --- | --- |  " >> $tablefile
for file_path in $(ls $tests_dir/*/test.sh | sort)
do
    test_name=$(basename $(dirname $file_path))
    echo "| $test_name | \`wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/tests/${test_name}/test.sh && bash test.sh\` |" >> $tablefile
done
git add $tablefile
git commit -am "Auto generated commit."
git push
