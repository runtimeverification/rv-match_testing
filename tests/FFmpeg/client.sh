# https://github.com/FFmpeg/FFmpeg.git
# acf70639fb534a4ae9b1e4c76153f0faa0bda190
sudo apt -y install yasm
./configure --cc=kcc --ld=kcc --disable-stripping --disable-asm --disable-inline-asm --disable-x86asm --extra-cflags="-std=gnu11 -frecover-all-errors"
make -j`nproc`
make -j`nproc` examples
