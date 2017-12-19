#!/bin/bash
rm -r dep1/
rm -r dep2/
rm -r dep3/
cp -r /var/lib/jenkins/jobs/rv-match-master/workspace/c-semantics/dist ./dep1/
cp -r /var/lib/jenkins/jobs/rv-match-master/workspace/errors/rv-error/bin ./dep2/
cp -r /var/lib/jenkins/jobs/rv-match-master/workspace/k/k-distribution/target/release/k/bin ./dep3/
PATH=$(pwd)/dep1:$(pwd)/dep2:$(pwd)/dep3:$PATH
