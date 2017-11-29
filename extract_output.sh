#!/bin/bash

spacer=" ========== "
build_dir=$(pwd)
for D in *_kcc_test; do
    if [ -d "${D}" ]; then
       echo $spacer${D%_kcc_test}$spacer
       echo "Entering ${D}."
       cd ${D}
       if [ -d "kcc_all" ] ; then 
          # Project expects to be built. We are interested in runtime output.
          echo "This project should have built."
       else
          # Project only has build output.
          echo "no kcc_all folder for this project"
          if [ -d "kcc_compile_out" ] ; then
             echo "There is compile output for this project."
             cd kcc_compile_out
             ls -c | cat
             cd $build_dir
          else
             echo "no kcc_compile_out for this project"
          fi
       fi
       echo "Leaving ${D}."
       cd $build_dir
       echo $spacer"/"${D%_kcc_test}$spacer
    fi
done
