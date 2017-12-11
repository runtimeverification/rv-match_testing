Table generated from Jenkins run.
Updated to the wiki page manually by Tim.
  
| project | conf gcc | make gcc | test gcc | conf kcc | make kcc | kcc conf | test kcc | open issue | clsd issue | 
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| bind9 | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :x: | :exclamation: | :grey_question: |  |  |
| bogosort | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :white_check_mark: |   | :grey_question: |  |  |
| cFE | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: |  |  |
| cineform | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| coreutils | :white_check_mark: | :x: | :grey_question: | :white_check_mark: | :x: | :exclamation: | :grey_question: |  |  |
| curl | :white_check_mark: | :white_check_mark: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| curve25519 | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :white_check_mark: |   | :grey_question: |  |  |
| dhcpcd | :white_check_mark: | :white_check_mark: | :grey_question: | :x: | :white_check_mark: |   | :grey_question: |  |  |
| dpkg | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| FFmpeg | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| getty | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :x: |   | :grey_question: |  |  |
| hashcat | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: |  |  |
| helloworld | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :white_check_mark: |   | :grey_question: |  |  |
| hostapd | :white_check_mark: | :x: | :grey_question: | :white_check_mark: | :x: |   | :grey_question: |  |  |
| libpcap | :white_check_mark: | :white_check_mark: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| libuv | :white_check_mark: | :white_check_mark: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| linux | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :white_check_mark: | :exclamation: | :grey_question: |  |  |
| LuaDist | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :x: | :exclamation: | :grey_question: |  |  |
| lua | :x: | :white_check_mark: | :x: | :x: | :white_check_mark: | :exclamation: | :x: |  |  |
| makefs | :white_check_mark: | :x: | :grey_question: | :white_check_mark: | :x: | :exclamation: | :grey_question: |  |  |
| mawk | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| mbedtls | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :x: | :exclamation: | :grey_question: |  |  |
| musl | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :x: |   | :grey_question: |  |  |
| netdata | :x: | :x: | :grey_question: | :x: | :x: | :exclamation: | :grey_question: |  |  |
| Open-Chargeport | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: |  |  |
| openssl | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :x: |   | :grey_question: |  |  |
| php-src | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| Remotery | :white_check_mark: | :x: | :grey_question: | :white_check_mark: | :x: |   | :grey_question: |  |  |
| Reptile | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | :white_check_mark: |   | :grey_question: |  |  |
| spin | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: |  |  |
| systemc-2.3 | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: |  |  |
| SystemC | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | :grey_question: |  |  |
| tcpdump | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| tmux | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
| vim | :white_check_mark: | :white_check_mark: | :grey_question: | :x: | :white_check_mark: |   | :grey_question: |  |  |
| wget | :x: | :x: | :grey_question: | :x: | :x: |   | :grey_question: |  |  |
  
| project | standalone script |  
| --- | --- |  
| bind9 | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/bind9/test.sh && bash test.sh` |
| bogosort | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/bogosort/test.sh && bash test.sh` |
| cFE | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/cFE/test.sh && bash test.sh` |
| cineform | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/cineform/test.sh && bash test.sh` |
| coreutils | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/coreutils/test.sh && bash test.sh` |
| curl | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/curl/test.sh && bash test.sh` |
| curve25519 | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/curve25519/test.sh && bash test.sh` |
| dhcpcd | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/dhcpcd/test.sh && bash test.sh` |
| dpkg | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/dpkg/test.sh && bash test.sh` |
| FFmpeg | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/FFmpeg/test.sh && bash test.sh` |
| getty | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/getty/test.sh && bash test.sh` |
| hashcat | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/hashcat/test.sh && bash test.sh` |
| helloworld | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/helloworld/test.sh && bash test.sh` |
| hostapd | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/hostapd/test.sh && bash test.sh` |
| libpcap | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/libpcap/test.sh && bash test.sh` |
| libuv | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/libuv/test.sh && bash test.sh` |
| linux | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/linux/test.sh && bash test.sh` |
| LuaDist | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/LuaDist/test.sh && bash test.sh` |
| lua | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/lua/test.sh && bash test.sh` |
| makefs | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/makefs/test.sh && bash test.sh` |
| mawk | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/mawk/test.sh && bash test.sh` |
| mbedtls | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/mbedtls/test.sh && bash test.sh` |
| musl | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/musl/test.sh && bash test.sh` |
| netdata | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/netdata/test.sh && bash test.sh` |
| Open-Chargeport | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/Open-Chargeport/test.sh && bash test.sh` |
| openssl | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/openssl/test.sh && bash test.sh` |
| php-src | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/php-src/test.sh && bash test.sh` |
| Remotery | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/Remotery/test.sh && bash test.sh` |
| Reptile | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/Reptile/test.sh && bash test.sh` |
| spin | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/spin/test.sh && bash test.sh` |
| systemc-2.3 | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/systemc-2.3/test.sh && bash test.sh` |
| SystemC | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/SystemC/test.sh && bash test.sh` |
| tcpdump | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/tcpdump/test.sh && bash test.sh` |
| tmux | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/tmux/test.sh && bash test.sh` |
| vim | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/vim/test.sh && bash test.sh` |
| wget | `wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/wget/test.sh && bash test.sh` |
