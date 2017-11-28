spacer=" ========== "
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
          echo "no kcc_all"
          cd kcc_compile_out
       fi
       echo "Leaving ${D}."
       cd ..
       echo $spacer"/"${D%_kcc_test}$spacer
    fi
done
