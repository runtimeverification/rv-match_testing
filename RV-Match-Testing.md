

| project | touch date | compile [gcc] | test [gcc] | compile [kcc] | test [kcc] | issue [open] | issue [closed] |
| --- | --- | --- | --- | --- | --- | --- | --- |
| bind9 | 22 Nov 2017 | ✅ |❓| ❌ | ❌ |[548](https://github.com/runtimeverification/rv-match/issues/548)|.|
| coreutils | 22 Nov 2017 | ✅ |❓| ❌ | ❌ |[559](https://github.com/runtimeverification/rv-match/issues/559), [570](https://github.com/runtimeverification/rv-match/issues/570)|.|none
| FFmpeg | 22 Nov 2017 | ❓ | ❓ | ❓ | ❓ | [541](https://github.com/runtimeverification/rv-match/issues/541) | . | . |
| hostapd | 22 Nov 2017 | ✅ | ❓ | ✅ | ❓ | [587](https://github.com/runtimeverification/rv-match/issues/587) | . | . |
| lua-5.3.4 | 22 Nov 2017 | ✅ |❓| ✅ | ❌ | [601](https://github.com/runtimeverification/rv-match/issues/601)|.|
| mbedtls | 22 Nov 2017 | ✅ |❓| ❌ | ❌ | [558](https://github.com/runtimeverification/rv-match/issues/558)|[550](https://github.com/runtimeverification/rv-match/issues/550)|none
| netdata | 22 Nov 2017 | ❓ | ❓ | ❓ | ❓ | [544](https://github.com/runtimeverification/rv-match/issues/544) | . | . |
| openssl | 22 Nov 2017 | ✅ |❓|❌|❌| [547](https://github.com/runtimeverification/rv-match/issues/547)|.|


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