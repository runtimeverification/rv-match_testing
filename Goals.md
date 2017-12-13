[complete] 1. Integrate the folder structure change.  
[complete] 2. Have all current scripts `gcc` and `kcc` build results on the generated table.  
[complete] 3. User can configure a subset of tests to run.  
[todo] 4. Timestamps/date information is tracked on the table.  
[complete] 5. Integrate at least one project test into the Jenkin's testing system to exercise that process which may eventually take place.  
[complete] 6. Table generating script finds relevant issues and links them in their columns.  
[todo] 7. Get a test working for `cFE`.  
[complete] 8. Get a job going on the `jenkins` machine.  
[priority overridden by 12] 9. Write a script which produces set {projects which build scripts have been updated since their last run}.  
[todo] 10. There are multiple individual tests that can be done individually for projects like {`cFE`, `spin`}. The scripts should be able to handle reporting results for more than just one test.  
[todo] 11. Work out build dependencies that don't work on Jenkins but do work locally on my personal VM.  
[complete] 12. Separate build and tests so build doesn't need to be redone for each test.  
[todo] 13. Create default _extract() and _extract_tests() in prepare.sh so not every script needs them. Also, allow for _build_gcc() and _build_kcc() functions to exist and be checked so the project can prioritize them over the generic _build() function.  