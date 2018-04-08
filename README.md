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

- Post jenkins debug steps.
    - [1.] Open jenkins perhaps starting from the `private` page. Also open that job's `log/<build-num>-<set-name>/` to see the logs and output for that run. Note that the `.log` will also be in the build's console if it was ran as single project instead of a set.
    - [2.] Note: Usually you can skip this step. A container will be destroyed upon exit unless `-E` option was used, so if it wasn't, then have the test run again in one of the temporary oriented jobs: `rv-match_development` `rv-match_trusty_testing` `rv-match_testing` configuring that jenkins job with the top-level script `bash -ex jenkins_run.sh -eEPt bind9-alt` will test `rvpredict` (`-P`, without which it will test `rv-match`) including `unit tests` (`-t`) with the last container used for that job (`-e`) then leave the container running for manual inspection (`-E`). Also note, if you want to build cleanly again from scratch, exclude `-e` to generate a fresh container or add `-b` to force a build again, but always report it if you do. That should not normally happen since the project checks for changes to many things including the build script and should rebuild from the interesting point on unless work is being done on the rv-match_testing project itself.
    - [3.] Log into rvwork-2 `ssh -p 6666 username@office.runtimeverification.com`
    - [4.] Log into the container with `lxc exec <jenkins-job-name-replacing-underscores-with-hyphens> -- bash`
        - For example, `lxc exec rv-match-development -- bash` connects to the container associated with the jenkins job `rv-match_development`.
        - Note: the container name is the same (with hyphens for underscores) as the jenkins job name, use `lxc list`.
    - [5.] `cd rv-match_testing/`
    - [6. option 1] To build/run a project, `bash run-set.sh -P helloworld` runs helloworld with rv-predict using the same download, build, and test folders as the report.
    - [6. option 2] To build/run a set of projects stored at `sets/<set>.ini`, run `bash run-set.sh -P <set>`.
    - [6. option 3] To manually inspect a project build or testing folder, `cd tests/bind9/rvpc/build/bind9/` because:
        - `tests/` contains project specific files.

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
 - E - leave container alive
 - q - quick
       - skip updating rv-match
       - (will update to skip more)
 - p - prepare only
       - only installs dependencies and downloads, not build
 - P - rv-predict
       - runs and reports gcc and rvpc, not kcc
 - T - Trusty
       - uses Trusty container instead of Xenial
 - o - old machine
       - uses scripts that work with lxc (instead of lcd) using the master machine copying a Trusty source container
 - b - force build
       - build a project even when the hash matches
 - J - persistent
       - use a persistent container and keep dependency, download, build, and unit test folders in tact for retry runs.
 - standalone options are limited to `rsatgpPb`
