#wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/project_testing.sh && bash project_testing.sh
git clone https://github.com/TimJSwan89/rv-match_testing.git
build_dir=$(pwd)
cd rv-match_testing
git pull
bash run_all.sh
cd $build_dir
rm project_testing.sh
