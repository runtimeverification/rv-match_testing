

| project | touch date | compile [gcc] | test [gcc] | compile [kcc] | test [kcc] | issue [open] | issue [closed] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| bind9 | ? | ✅ |❓| ❌ | ❌ |[548](https://github.com/runtimeverification/rv-match/issues/548)|.|
| coreutils | ? | ✅ |❓| ❌ | ❌ |[559](https://github.com/runtimeverification/rv-match/issues/559), [570](https://github.com/runtimeverification/rv-match/issues/570)|.|none
| FFmpeg | ? | ❓ | ❓ | ❓ | ❓ | [541](https://github.com/runtimeverification/rv-match/issues/541) | . | . |
| hostapd | 22 Nov 2017 | ✅ | ❓ | ✅ | ❓ | [587](https://github.com/runtimeverification/rv-match/issues/587) | . | . |
| lua-5.3.4 | 20 Nov 2017 | ✅ |❓| ✅ | ❌ | [601](https://github.com/runtimeverification/rv-match/issues/601)|.|
| mbedtls | ? | ✅ |❓| ❌ | ❌ | [558](https://github.com/runtimeverification/rv-match/issues/558)|[550](https://github.com/runtimeverification/rv-match/issues/550)|none
| netdata | ? | ❓ | ❓ | ❓ | ❓ | [544](https://github.com/runtimeverification/rv-match/issues/544) | . | . |
| openssl | ? | ✅ |❓|❌|❌| [547](https://github.com/runtimeverification/rv-match/issues/547)|.|
| _ | . | . | . | . | . | . | . | . |


| project | standalone script |
| --- | --- |
| lua-5.3.4 | `wget https://raw.githubusercontent.com/TimJSwan89/rv-match_testing/master/lua-5.3.4_kcc_test.sh; sh lua-5.3.4_kcc_test.sh`

**Legend:**

| description | symbol |
| --- | --- |
| pass | :white_check_mark: |
| fail | :x: |
| not available in project | :exclamation: |
| unknown; todo | :question: |