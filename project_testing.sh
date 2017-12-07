#wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/project_testing.sh && bash project_testing.sh
git clone https://github.com/runtimeverification/rv-match_testing.git
user_dir=$(pwd)
cd rv-match_testing/
git pull
bash run_set.sh sets/quickset.ini
cd $user_dir
rm project_testing.sh
