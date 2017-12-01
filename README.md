# rv-match_testing

## Setup

```
cd rv-match_testing
chmod +x run_all.sh && chmod +x tests/*/test.sh
./run_all.sh
```

## Folder Structure

- log/
  - 2017-11-22-14:52:25.log
  - 2017-11-19-14:37:16.log
  - ...
- tests/
  - <test_name>/
    - build/  
      _Downloaded files are put in here and compiled._
    - log/
      - 2017-11-22-14:52:25.log
      - 2017-11-19-14:37:16.log
      - ...
    - test.sh
- extract_output.sh
- prepare.sh  
  _This script will be put at the beginning of each test script passing the test name. This should be non-executable._
- project_testing.sh
- run_all.sh
