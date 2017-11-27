

| project | touch date | compile [gcc] | test [gcc] | compile [kcc] | test [kcc] | issue [open] | issue [closed] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| bind9 | 22 Nov 2017 | :white_check_mark: |:question:| :x: | :grey_question: |[548](https://github.com/runtimeverification/rv-match/issues/548)|.|
| coreutils | 22 Nov 2017 | :white_check_mark: |:question:| :x: | :grey_question: |[559](https://github.com/runtimeverification/rv-match/issues/559), [570](https://github.com/runtimeverification/rv-match/issues/570)|.|none
| FFmpeg | 22 Nov 2017 | :white_check_mark: | :white_check_mark: | :x: | :grey_question: | [541](https://github.com/runtimeverification/rv-match/issues/541) | . | . |
| hostapd | 22 Nov 2017 | :white_check_mark: | :question: | :warning: | :question: | [587](https://github.com/runtimeverification/rv-match/issues/587) | . | . |
| lua-5.3.4 | 22 Nov 2017 | :white_check_mark: |:question:| :white_check_mark: | :x: | [601](https://github.com/runtimeverification/rv-match/issues/601)|.|
| mbedtls | 22 Nov 2017 | :white_check_mark: |:question:| :x: | :grey_question: | [558](https://github.com/runtimeverification/rv-match/issues/558)|[550](https://github.com/runtimeverification/rv-match/issues/550)|none
| netdata | 22 Nov 2017 | :white_check_mark: | :question: | :x: | :grey_question: | [544](https://github.com/runtimeverification/rv-match/issues/544) | . | . |
| openssl | 22 Nov 2017 | :white_check_mark: |:question:|:x:|:grey_question:| [547](https://github.com/runtimeverification/rv-match/issues/547)|.|


**Legend:**

| description | symbol | hardcoded symbol (different for some browsers)
| --- | --- | --- |
| pass | :white_check_mark: | ✅ |
| passes only with special patch | :warning: | ⚠️ |
| fail | :x: | ❌ |
| not available in project | :exclamation: | ❗️ |
| todo | :question: | ❓ |
| needs prerequisite | :grey_question: | ❔ |


| project | standalone script |
| --- | --- |
| bind9 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/bind9_kcc_test.sh && bash bind9_kcc_test.sh` |
| coreutils | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/coreutils_kcc_test.sh && bash coreutils_kcc_test.sh` |
| FFmpeg | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/FFmpeg_kcc_test.sh && bash FFmpeg_kcc_test.sh` |
| hostapd | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/hostapd_kcc_test.sh && bash hostapd_kcc_test.sh` |
| lua-5.3.4 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/lua-5.3.4_kcc_test.sh && bash lua-5.3.4_kcc_test.sh` |
| mbedtls | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/mbedtls_kcc_test.sh && bash mbedtls_kcc_test.sh` |
| netdata | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/netdata_kcc_test.sh && bash netdata_kcc_test.sh` |
| openssl | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/openssl_kcc_test.sh && bash openssl_kcc_test.sh` |