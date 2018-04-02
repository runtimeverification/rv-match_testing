#!/bin/bash
for d in $(find -type d); do
  echo $d,$(cd $d; ls | grep "CWE.*\.c$" | sed -e 's/^.*__//' -e 's/^\(.*_[0-9][0-9]*\).*$/\1/' | sort -u | wc -l)
done | cut -f2 -d, | paste -sd+ | bc -ql
