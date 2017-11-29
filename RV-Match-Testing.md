

| project | touch date | compile [gcc] | test [gcc] | compile [kcc] | test [kcc] | issue [open] | issue [closed] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| bind9 | 22 Nov 2017 | :white_check_mark: |:question:| :x: | :grey_question: |[548](https://github.com/runtimeverification/rv-match/issues/548)|.|
| bogosort | 29 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|[583](https://github.com/runtimeverification/rv-match/issues/583)|
| cFE | 28 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|.|
| coreutils | 22 Nov 2017 | :white_check_mark: |:question:| :x: | :grey_question: |[559](https://github.com/runtimeverification/rv-match/issues/559), [570](https://github.com/runtimeverification/rv-match/issues/570)|[561](https://github.com/runtimeverification/rv-match/issues/561)|none
| curve25519 | 29 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|[590](https://github.com/runtimeverification/rv-match/issues/590)|
| dpkg | 29 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |[613](https://github.com/runtimeverification/rv-match/issues/613)|[594](https://github.com/runtimeverification/rv-match/issues/594)|
| FFmpeg | 22 Nov 2017 | :white_check_mark: | :white_check_mark: | :x: | :grey_question: | [541](https://github.com/runtimeverification/rv-match/issues/541) | . | . |
| hashcat | 29 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|[564](https://github.com/runtimeverification/rv-match/issues/564)|
| hostapd | 22 Nov 2017 | :white_check_mark: | :question: | :warning: | :question: | [587](https://github.com/runtimeverification/rv-match/issues/587) | . | . |
| libuv | 27 Nov 2017 | :white_check_mark: | :question: | :x: | :grey_question:| [555](https://github.com/runtimeverification/rv-match/issues/555) | . |
| linux | 27 Nov 2017 | :x: |:grey_question:| :grey_question: | :grey_question: |.|.|
| lua-5.3.4 | 22 Nov 2017 | :white_check_mark: |:question:| :white_check_mark: | :x: | [601](https://github.com/runtimeverification/rv-match/issues/601)|.|
| mbedtls | 22 Nov 2017 | :white_check_mark: |:question:| :x: | :grey_question: | [558](https://github.com/runtimeverification/rv-match/issues/558)|[550](https://github.com/runtimeverification/rv-match/issues/550)|none
| netdata | 22 Nov 2017 | :white_check_mark: | :question: | :x: | :grey_question: | [544](https://github.com/runtimeverification/rv-match/issues/544) | . | . |
| Open-Chargeport | 28 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|.|
| openssl | 22 Nov 2017 | :white_check_mark: |:question:|:x:|:grey_question:| [547](https://github.com/runtimeverification/rv-match/issues/547)|.|
| php-src | 27 Nov 2017 | :x: |:grey_question:| :grey_question: | :grey_question: |.|.|
| Reptile | 29 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|[572](https://github.com/runtimeverification/rv-match/issues/572)|
| SystemC | 28 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|.|
| systemc-2.3 | 28 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|.|
| tmux | 29 Nov 2017 | :question: |:grey_question:| :grey_question: | :grey_question: |.|[552](https://github.com/runtimeverification/rv-match/issues/552)|

**Legend:**

| description | symbol | hardcoded symbol (different for some browsers)
| --- | --- | --- |
| pass | :white_check_mark: | ✅ |
| passes only with special patch | :warning: | ⚠️ |
| fail | :x: | ❌ |
| not available in project | :exclamation: | ❗️ |
| todo | :question: | ❓ |
| needs prerequisite | :grey_question: | ❔ |

To test all these projects, run this command:
```
wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/project_testing.sh && bash project_testing.sh
```

| project | standalone script |
| --- | --- |
| bind9 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/bind9_kcc_test.sh && bash bind9_kcc_test.sh` |
| cFE | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/cFE_kcc_test.sh && bash cFE_kcc_test.sh` |
| bogosort | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/bogosort_kcc_test.sh && bash bogosort_kcc_test.sh` |
| coreutils | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/coreutils_kcc_test.sh && bash coreutils_kcc_test.sh` |
| curve25519 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/curve25519_kcc_test.sh && bash curve25519_kcc_test.sh` |
| dpkg | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/dpkg_kcc_test.sh && bash dpkg_kcc_test.sh` |
| FFmpeg | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/FFmpeg_kcc_test.sh && bash FFmpeg_kcc_test.sh` |
| hashcat | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/hashcat_kcc_test.sh && bash hashcat_kcc_test.sh` |
| hostapd | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/hostapd_kcc_test.sh && bash hostapd_kcc_test.sh` |
| libuv | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/libuv_kcc_test.sh && bash libuv_kcc_test.sh` |
| linux | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/linux_kcc_test.sh && bash linux_kcc_test.sh` |
| lua-5.3.4 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/lua-5.3.4_kcc_test.sh && bash lua-5.3.4_kcc_test.sh` |
| mbedtls | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/mbedtls_kcc_test.sh && bash mbedtls_kcc_test.sh` |
| netdata | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/netdata_kcc_test.sh && bash netdata_kcc_test.sh` |
| Open-Chargeport | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/Open-Chargeport_kcc_test.sh && bash Open-Chargeport_kcc_test.sh` |
| openssl | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/openssl_kcc_test.sh && bash openssl_kcc_test.sh` |
| php-src | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/php-src_kcc_test.sh && bash php-src_kcc_test.sh` |
| Reptile | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/Reptile_kcc_test.sh && bash Reptile_kcc_test.sh` |
| SystemC | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/SystemC_kcc_test.sh && bash SystemC_kcc_test.sh` |
| systemc-2.3 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/systemc-2.3_kcc_test.sh && bash systemc-2.3_kcc_test.sh` |
| tmux | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/tmux_kcc_test.sh && bash tmux_kcc_test.sh` |