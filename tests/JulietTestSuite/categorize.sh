#! /usr/bin/env bash

# Obtained from Chris Hathhorn
# March 28 2018
# > categorize.sh
#   fetch.sh
#   juliet.pl
#   runner.pl

#cd juliet/C/testcases

rm -rf ../../not_applicable

DIR=../../not_applicable/misc/
mkdir -p $DIR

echo "Moving tests that aren't applicable"

# these are security properties, but are not necessarily undefined
mv CWE15_*/ $DIR
# mv CWE204_*/ $DIR
mv CWE222_*/ $DIR
mv CWE223_*/ $DIR
mv CWE226_*/ $DIR
mv CWE244_*/ $DIR
mv CWE247_*/ $DIR
mv CWE252_*/ $DIR
mv CWE256_*/ $DIR
mv CWE259_*/ $DIR
mv CWE272_*/ $DIR
mv CWE273_*/ $DIR
mv CWE284_*/ $DIR
mv CWE319_*/ $DIR
mv CWE321_*/ $DIR
mv CWE327_*/ $DIR
mv CWE328_*/ $DIR
mv CWE338_*/ $DIR
mv CWE377_*/ $DIR
# mv CWE547_*/ $DIR
# mv CWE560_*/ $DIR
mv CWE591_*/ $DIR
mv CWE620_*/ $DIR
mv CWE78_*/ $DIR
mv CWE534_*/ $DIR
mv CWE535_*/ $DIR
mv CWE134_*/ $DIR
mv CWE426_*/ $DIR
mv CWE427_*/ $DIR

# standard library, limited coverage
mv CWE475_*/ $DIR

# these are bad programming practices, but are not necessarily undefined
mv CWE478_*/ $DIR
mv CWE36_*/ $DIR
# mv CWE365_*/ $DIR
mv CWE401_*/ $DIR
mv CWE481_*/ $DIR
mv CWE482_*/ $DIR
mv CWE23_*/ $DIR
mv CWE242_*/ $DIR
mv CWE546_*/ $DIR
mv CWE561_*/ $DIR
mv CWE563_*/ $DIR
mv CWE570_*/ $DIR
mv CWE571_*/ $DIR
mv CWE511_*/ $DIR
mv CWE789_*/ $DIR
mv CWE484_*/ $DIR
mv CWE483_*/ $DIR
# mv CWE187_*/ $DIR
mv CWE195_*/ $DIR
mv CWE196_*/ $DIR
mv CWE197_*/ $DIR
mv CWE253_*/ $DIR
mv CWE480_*/ $DIR
mv CWE690_*/ $DIR
mv CWE674_*/ $DIR
mv CWE587_*/ $DIR
# mv CWE489_*/ $DIR
mv CWE468_*/ $DIR
mv CWE467_*/ $DIR
mv CWE459_*/ $DIR
# mv CWE392_*/ $DIR
mv CWE390_*/ $DIR
mv CWE391_*/ $DIR
# mv CWE135_*/ $DIR
mv CWE617_*/ $DIR

# these are system dependent tests, but are not necessarily undefined
mv CWE114_*/ $DIR
mv CWE605_*/ $DIR
mv CWE785_*/ $DIR
mv CWE188_*/ $DIR
mv CWE666_*/ $DIR
mv CWE366_*/ $DIR

# just io tests
mv CWE123_*/ $DIR
# mv CWE772_*/ $DIR
mv CWE464_*/ $DIR
mv CWE404_*/ $DIR
mv CWE367_*/ $DIR

# moving "empty" directories
mv CWE676_*/ $DIR
mv CWE675_*/ $DIR
mv CWE672_*/ $DIR
mv CWE606_*/ $DIR
mv CWE440_*/ $DIR
mv CWE400_*/ $DIR
mv CWE397_*/ $DIR
mv CWE396_*/ $DIR

# see "The value of a pointer to an object whose lifetime has ended is used (6.2.4)" and "(7.22.3) The lifetime of an allocated object extends from the allocation until the deallocation."
mv CWE415_*/ $DIR
mv CWE416_*/ $DIR
# in the good branches, using value of a local after its lifetime has ended
mv CWE476_*/ $DIR
# there are tests for unsigned overflow, and there are tests for things that overflow before promotion but not afterwards
mv CWE190_*/ $DIR
mv CWE191_*/ $DIR

# we catch these errors, but attempting to run this exhausts memory
mv CWE680_*/ $DIR

# assume static analysis
# mv CWE129_*/ $DIR

# this one is usually okay, but mallocs 4 gigs of ram
mv CWE194_*/ $DIR
 
# c++ tests
mv CWE762_*/ $DIR
# mv CWE248_*/ $DIR
# mv CWE374_*/ $DIR

# these variations introduce undefined behavior (reads uninit memory in good branch)
# mv CWE457_*/CWE457_*__*_64*.c $DIR
# mv CWE457_*/CWE457_*__*_63*.c $DIR

# these variations aren't actually undefined
mv CWE469_*/ $DIR

# not going to deal with signal stuff
DIR=../../not_applicable/signal/
mkdir -p $DIR
mv CWE364_*/ $DIR
mv CWE479_*/ $DIR

echo "Moving tests that use functions we don't handle or are not standard"
# DIR=../../not_applicable/alloca/
# mkdir -p $DIR
# mv `ls */*alloca*.c` $DIR
# DIR=../../not_applicable/float/
# mkdir -p $DIR
# mv `ls */*float*.c` $DIR
DIR=../../not_applicable/io/
mkdir -p $DIR
mv `ls **/*socket*.c` $DIR
# mv `ls **/*fscanf*.c` $DIR
# mv `ls **/*fgets*.c` $DIR

DIR=../../not_applicable/wchar/
mkdir -p $DIR
mv `ls **/*wchar*.c` $DIR
DIR=../../not_applicable/cpp/
mkdir -p $DIR
rm -f `ls **/main_linux.cpp`
rm -f `ls **/main.cpp`
mv -f `ls **/*.cpp` $DIR

DIR=../../not_applicable/environment/
mkdir -p $DIR
mv -f `ls **/*Environment*.c` $DIR
mv -f `ls **/*_console_*.c` $DIR
# mv -f `ls **/*fromFile*.c` $DIR

# these tests assume we're doing static analysis and can actually be correct dynamically
# DIR=../../not_applicable/random/
# mkdir -p $DIR
# mv `ls */*rand*.c` $DIR
# mv `grep -l 'global_returns_t_or_f' */*.c` $DIR

# echo "Fixing some tests that have undefined behavior in the good branches"
# # there is some undefined behavior in some of the tests where they read a value that hasn't been initialized.  This fixes those cases
# perl -i -p -e 'undef $/; s/^    (void|char|int|long|long long|double|twoints) \* data;(\s+\1 \* \*data_ptr1 = &data;\s+\1 \* \*data_ptr2 = &data;)/    \1 \* data = 0;\2/gsm' */*.c
# 
# echo "Changing \"_snprintf\" to \"snprintf\""
# perl -i -p -e 's/(\s)_snprintf/\1snprintf/gsm' */*.c
# 
# echo "Commenting out use of wprintf"
# sed -i 's/\(wprintf(L"%s\\n", line);\)/\/\/ \1/' ../testcasesupport/io.c
# 
# echo "Adding newlines to files that need them"
# FIX=CWE758_Undefined_Behavior/CWE758_Undefined_Behavior__no_return_implicit_01.c
# echo | cat $FIX - > fix.tmp
# mv fix.tmp $FIX
# FIX=CWE758_Undefined_Behavior/CWE758_Undefined_Behavior__no_return_01.c
# echo | cat $FIX - > fix.tmp
# mv fix.tmp $FIX
# FIX=CWE758_Undefined_Behavior/CWE758_Undefined_Behavior__bare_return_01.c
# echo | cat $FIX - > fix.tmp
# mv fix.tmp $FIX
# FIX=CWE758_Undefined_Behavior/CWE758_Undefined_Behavior__bare_return_implicit_01.c
# echo | cat $FIX - > fix.tmp
# mv fix.tmp $FIX

OUT_DIR=../../filtered_tests
rm -rf $OUT_DIR
mkdir -p $OUT_DIR

echo "Saving the known good tests to $OUT_DIR"

GOOD_DIR=../../good
rm -rf $GOOD_DIR
mkdir -p $GOOD_DIR

GOODTESTS='CWE121_* CWE122_* CWE124_* CWE126_* CWE127_* CWE369_* CWE457_* CWE562_* CWE590_* CWE665_* CWE685_* CWE688_* CWE758_* CWE761_* CWE588_*'
for dir in $GOODTESTS
do
	echo -n "$dir: "
	ls -1 $dir/ | sed 's/\([1-9][0-9]\?\)[a-z]\?\.c/\1\.c/' | sort | uniq | wc -l
	mv $dir/ $GOOD_DIR/
done

for dir in $GOOD_DIR/*
do
	for file in $dir/*.c
	do
		# filename=`basename $file`
		BASEFILE=$(echo $file | sed 's/\([1-9][0-9]\?\)[a-z]\?\.c/\1/')
		mv -f $BASEFILE* $OUT_DIR/ 2> /dev/null
	done
done

echo "Building io.c utility library with kcc"
cd ../testcasesupport
kcc -c io.c

echo "Done!"
