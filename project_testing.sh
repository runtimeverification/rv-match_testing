#wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/project_testing.sh && bash project_testing.sh
git clone https://github.com/TimJSwan89/rv-match_testing.git
STRTDIR=$(pwd)
cd rv-match_testing
bash run_all.sh
cd $STRTDIR
rm project_testing.sh
