# rv-match_testing

## Standalone

 - To run a project as a standalone, run tests/\<project\>/test.sh [standalone-options]
 - Example:
```
wget https://raw.githubusercontent.com/runtimeverification/rv-match_testing/master/tests/helloworld/test.sh && bash test.sh -t
```
    - will run the helloworld project with unit tests

## Jenkins

 - Usage: bash jenkins_run.sh [options] (project | set)
    - tests/\<project\>/test.sh are projects
    - sets/\<set\>.ini are sets

 - Example: `bash -ex jenkins_run.sh helloworld`
    - runs helloworld projects
 - Example: `bash -ex jenkins_run.sh -r regression`
    - runs all projects in regression set
    - format test to -r flag

## Flags

 - r - regression
       - only runs and reports kcc, not gcc
       - xml named regression, not report
 - s - status
       - only reports most recent results, not runs
 - a - acceptance
       - only reports make, not configure or kcc_config
       - xml named acceptance, not report
 - t - unit tests
       - also runs and reports project unit tests
 - d - development
       - container checks out development git branch
 - g - gcc only
       - skip kcc, skip rvpc even if -P
 - e - reuse container
       - uses the old container if it exists
       - (may update to retain container too)
 - q - quick
       - skip updating rv-match
       - (will update to skip more)
 - p - prepare only
       - only installs dependencies and downloads, not build
 - P - rv-predict
       - runs and reports gcc and rvpc, not kcc
 - standalone options are limited to `rsatgpP`
