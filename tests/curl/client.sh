sudo apt -y install libssl-dev
CC=kcc CFLAGS="-std=gnu11 -no-pedantic -frecover-all-errors -fprofile-arcs -ftest-coverage -g -O0" LD=kcc cmake -DCURL_STATICLIB=ON .
./configure --enable-curldebug
make -j`nproc`
make -j`nproc` tests
cd tests/
./runtests.pl 1
