#!/bin/sh
#
# `match.sh` builds and/or runs the NIST Juliet test suite with
# RV-Match, by default.  It also has two personalities that build
# and run Juliet with RV-Predict/C. To activate those personalities,
# copy/link `match.sh` to `thread-predict.sh` and `signal-predict.sh` so
# that you can run it by those names.
#
# The `thread-predict.sh` personality builds and runs only the
# Juliet tests that may contain thread/thread data races.  The
# `signal-predict.sh` personality builds and runs the tests that
# may contain signal/thread data races.
#
# All personalities require at least one argument to tell the script
# an action to perform.  Available actions are:
#
# `build`       create executables
# `run`         run the executables created by the `build` step
# `reset-[build|run]`       perform the next action from its beginning---i.e., do
#               not restart the action where the script previously left
#               off
# `html`	produce html from json UB
#
# This script must run at the top of the Juliet 1.3 sources, where
# there is a subdirectory called `C`. 
#
# FILES
#
# This script relies on lists of files under `skiplists/match/` (for
# the `match.sh` personality) and under # `skiplists/predict/` (for
# the `*-predict.sh` personalities) to know which Juliet `.c` modules
# to avoid building & running.  As of Thu Apr  5 15:54:57 CDT 2018,
# this is the content of `skiplists/`:
#
# `skiplists/predict/syntax-error`
#     `.c` files having syntax errors!
# `skiplists/match/runtime_crash`
#     programs that crash RV-Match at runtime
# `skiplists/match/assumes_int_as_wide_as_size_t`
#     programs that appear to assume INT_MAX == SIZE_MAX, which isn't
#     true on 64-bit systems; these can probably be made to work with
#     `kcc -m32`.
# `skiplists/match/blocks`
#     programs that run forever because either they contain infinite
#     loops, or they wait for an event that will never come, like a
#     socket connection.
# `skiplists/match/long_duration`
#     programs that in tests ran longer than David had patience for;
#     they may or may not contain infinite loops.
# `skiplists/match/alloca`
#     programs that use alloca(3) in a way that `kcc` does not support;
#     possibly they are non-portable programs, or we need to use different
#     flags than the defaults with `kcc`.
# `skiplists/match/compile_crash`
#     programs that `kcc` cannot compile without crashing
#
# This script produces executables under directory `match/` in its
# `match.sh` personality, and under directory `predict/` in its
# `*-predict.sh` personalities.  The executables are named after the
# `.c` files they derive from.
#
# CAVEAT
#
# This script does not run tests parallel. This could be helpful.
#
# BUGS
#
# Because RV-Predict/C struggles with the sheer number of potential data
# races in the CWE366 test cases, `thread-predict.sh` does not analyze
# those, it just leaves `.trace` files beside their corresponding
# executables in `predict/`.
#
# MODIFICATIONS (Tim)
# - Support files are only built once for each top level build command
#	rather than for each test.
# - Modules are no longer individual c files, they are test basenames.
#	This means that the previously unused tests ending in
#	`[a-z].c` and `C/testcases/*/s[0-9][0-9]/*.c` are now used.
# - Build and run progress are tracked by separate files. Run now
#	automatically stops at the last compiled module.
# - Produce html report.
#
# AUTHORS
#
# David Young (david.young@runtimeverification.com)
# Timothy Swan

set -e
set -u

cleanup_hook()
{
	trap - EXIT ALRM HUP INT PIPE QUIT TERM

	reason=$1
	if [ ${reason} != EXIT ]; then
		echo "$(basename $0): caught signal $reason.  Cleaning up." 1>&2
	fi
	rm -rf $tmpdir
	if [ -v json ] && [ -e ${json} ] ; then echo "Keeping a json backup." ; cp $json $json.backup ; fi
	exit $exitcode
}

trap_with_reason()
{
	func="$1"
	shift
	for reason; do
		trap "$func $reason" $reason
	done
}

signal_cases()
{ # 1
	echo C/testcases/CWE364_Signal_Handler_Race_Condition
}

thread_cases()
{ # 2
	echo C/testcases/CWE366_Race_Condition_Within_Thread
	echo C/testcases/CWE367_TOC_TOU
}

unused_by_match_cases()
{ # 75
	cat<<EOF
C/testcases/CWE114_Process_Control
C/testcases/CWE15_External_Control_of_System_or_Configuration_Setting
C/testcases/CWE176_Improper_Handling_of_Unicode_Encoding
C/testcases/CWE222_Truncation_of_Security_Relevant_Information
C/testcases/CWE223_Omission_of_Security_Relevant_Information
C/testcases/CWE226_Sensitive_Information_Uncleared_Before_Release
C/testcases/CWE23_Relative_Path_Traversal
C/testcases/CWE242_Use_of_Inherently_Dangerous_Function
C/testcases/CWE247_Reliance_on_DNS_Lookups_in_Security_Decision
C/testcases/CWE252_Unchecked_Return_Value
C/testcases/CWE253_Incorrect_Check_of_Function_Return_Value
C/testcases/CWE256_Plaintext_Storage_of_Password
C/testcases/CWE259_Hard_Coded_Password
C/testcases/CWE272_Least_Privilege_Violation
C/testcases/CWE273_Improper_Check_for_Dropped_Privileges
C/testcases/CWE284_Improper_Access_Control
C/testcases/CWE319_Cleartext_Tx_Sensitive_Info
C/testcases/CWE321_Hard_Coded_Cryptographic_Key
C/testcases/CWE325_Missing_Required_Cryptographic_Step
C/testcases/CWE327_Use_Broken_Crypto
C/testcases/CWE328_Reversible_One_Way_Hash
C/testcases/CWE338_Weak_PRNG
C/testcases/CWE364_Signal_Handler_Race_Condition
C/testcases/CWE366_Race_Condition_Within_Thread
C/testcases/CWE36_Absolute_Path_Traversal
C/testcases/CWE377_Insecure_Temporary_File
C/testcases/CWE390_Error_Without_Action
C/testcases/CWE391_Unchecked_Error_Condition
C/testcases/CWE396_Catch_Generic_Exception
C/testcases/CWE397_Throw_Generic_Exception
C/testcases/CWE398_Poor_Code_Quality
C/testcases/CWE400_Resource_Exhaustion
C/testcases/CWE404_Improper_Resource_Shutdown
C/testcases/CWE426_Untrusted_Search_Path
C/testcases/CWE427_Uncontrolled_Search_Path_Element
C/testcases/CWE440_Expected_Behavior_Violation
C/testcases/CWE459_Incomplete_Cleanup
C/testcases/CWE464_Addition_of_Data_Structure_Sentinel
C/testcases/CWE480_Use_of_Incorrect_Operator
C/testcases/CWE481_Assigning_Instead_of_Comparing
C/testcases/CWE482_Comparing_Instead_of_Assigning
C/testcases/CWE483_Incorrect_Block_Delimitation
C/testcases/CWE484_Omitted_Break_Statement_in_Switch
C/testcases/CWE500_Public_Static_Field_Not_Final
C/testcases/CWE506_Embedded_Malicious_Code
C/testcases/CWE510_Trapdoor
C/testcases/CWE511_Logic_Time_Bomb
C/testcases/CWE526_Info_Exposure_Environment_Variables
C/testcases/CWE534_Info_Exposure_Debug_Log
C/testcases/CWE535_Info_Exposure_Shell_Error
C/testcases/CWE546_Suspicious_Comment
C/testcases/CWE561_Dead_Code
C/testcases/CWE563_Unused_Variable
C/testcases/CWE570_Expression_Always_False
C/testcases/CWE571_Expression_Always_True
C/testcases/CWE591_Sensitive_Data_Storage_in_Improperly_Locked_Memory
C/testcases/CWE605_Multiple_Binds_Same_Port
C/testcases/CWE606_Unchecked_Loop_Condition
C/testcases/CWE615_Info_Exposure_by_Comment
C/testcases/CWE617_Reachable_Assertion
C/testcases/CWE620_Unverified_Password_Change
C/testcases/CWE666_Operation_on_Resource_in_Wrong_Phase_of_Lifetime
C/testcases/CWE667_Improper_Locking
C/testcases/CWE672_Operation_on_Resource_After_Expiration_or_Release
C/testcases/CWE674_Uncontrolled_Recursion
C/testcases/CWE675_Duplicate_Operations_on_Resource
C/testcases/CWE676_Use_of_Potentially_Dangerous_Function
C/testcases/CWE773_Missing_Reference_to_Active_File_Descriptor_or_Handle
C/testcases/CWE775_Missing_Release_of_File_Descriptor_or_Handle
C/testcases/CWE780_Use_of_RSA_Algorithm_Without_OAEP
C/testcases/CWE789_Uncontrolled_Mem_Alloc
C/testcases/CWE78_OS_Command_Injection
C/testcases/CWE832_Unlock_of_Resource_That_is_Not_Locked
C/testcases/CWE835_Infinite_Loop
C/testcases/CWE90_LDAP_Injection
EOF
}

windows_cases()
{ # 2
	cat<<EOF
C/testcases/CWE244_Heap_Inspection
C/testcases/CWE785_Path_Manipulation_Function_Without_Max_Sized_Buffer
EOF
}

match_cases()
{ # 40
	cat<<EOF
C/testcases/CWE121_Stack_Based_Buffer_Overflow
C/testcases/CWE122_Heap_Based_Buffer_Overflow
C/testcases/CWE123_Write_What_Where_Condition
C/testcases/CWE124_Buffer_Underwrite
C/testcases/CWE126_Buffer_Overread
C/testcases/CWE127_Buffer_Underread
C/testcases/CWE134_Uncontrolled_Format_String
C/testcases/CWE188_Reliance_on_Data_Memory_Layout
C/testcases/CWE190_Integer_Overflow
C/testcases/CWE191_Integer_Underflow
C/testcases/CWE194_Unexpected_Sign_Extension
C/testcases/CWE195_Signed_to_Unsigned_Conversion_Error
C/testcases/CWE196_Unsigned_to_Signed_Conversion_Error
C/testcases/CWE197_Numeric_Truncation_Error
C/testcases/CWE369_Divide_by_Zero
C/testcases/CWE401_Memory_Leak
C/testcases/CWE415_Double_Free
C/testcases/CWE416_Use_After_Free
C/testcases/CWE457_Use_of_Uninitialized_Variable
C/testcases/CWE467_Use_of_sizeof_on_Pointer_Type
C/testcases/CWE468_Incorrect_Pointer_Scaling
C/testcases/CWE469_Use_of_Pointer_Subtraction_to_Determine_Size
C/testcases/CWE475_Undefined_Behavior_for_Input_to_API
C/testcases/CWE476_NULL_Pointer_Dereference
C/testcases/CWE478_Missing_Default_Case_in_Switch
C/testcases/CWE479_Signal_Handler_Use_of_Non_Reentrant_Function
C/testcases/CWE562_Return_of_Stack_Variable_Address
C/testcases/CWE587_Assignment_of_Fixed_Address_to_Pointer
C/testcases/CWE588_Attempt_to_Access_Child_of_Non_Structure_Pointer
C/testcases/CWE590_Free_Memory_Not_on_Heap
C/testcases/CWE665_Improper_Initialization
C/testcases/CWE680_Integer_Overflow_to_Buffer_Overflow
C/testcases/CWE681_Incorrect_Conversion_Between_Numeric_Types
C/testcases/CWE685_Function_Call_With_Incorrect_Number_of_Arguments
C/testcases/CWE688_Function_Call_With_Incorrect_Variable_or_Reference_as_Argument
C/testcases/CWE690_NULL_Deref_From_Return
C/testcases/CWE758_Undefined_Behavior
C/testcases/CWE761_Free_Pointer_Not_at_Start_of_Buffer
C/testcases/CWE762_Mismatched_Memory_Management_Routines
C/testcases/CWE843_Type_Confusion
EOF
}

generalize()
{
	cat $@ | sed 's|[a-z]\{0,1\}.c$||' | sort | uniq
}

list_cases()
{
	$selected_cases
}

usage()
{
	echo "usage: ${prog} [build|run|reset-build|reset-run|html|download]" 1>&2
	exit 1
}

any_exist()
{
	for fn in "$@"; do
		[ -e "$fn" ] && return 0
	done
	return 1
}

filter_until_restart()
{
	if [ ! -e ${restart_fn} ] ; then
		cat
		return 0
	fi
	restart=$(head -n 1 ${restart_fn})
	while read src; do
		if [ ${src} = ${restart} ]; then
			echo ${src}
			break
		fi
		echo "-- skipping ${src} --" 1>&2
	done
	cat
}

list_modules()
{
	list_cases | while read cases_dir; do
		find ${cases_dir} -name '*.c'
	done | generalize | filter_until_restart | join -v 1 - $skiplist
}

do_build()
{
	mkdir -p ${outdir} ${sprtdir}
	$CC $JSON_REP -c $CPPFLAGS $COPTS $SUPPORT_IO -o $SUPPORT_OBJECT_IO
	$CC $JSON_REP -c $CPPFLAGS $COPTS $SUPPORT_STD_THREAD -o $SUPPORT_OBJECT_STD_THREAD
	list_modules | while read module; do
		if [ x${build_restart_fn:-} != x ]; then
			echo ${module} > ${build_restart_fn}
		fi
		echo "============="
		echo "-- $(basename $module) --"
		echo $(find $(dirname $module) -name "$(basename $module)*.c" | tr '\r\n' ' ')
		echo "compiling..."
		set +e
		$CC $JSON_REP $CPPFLAGS $COPTS $SUPPORT_OBJECT_IO $SUPPORT_OBJECT_STD_THREAD \
		    -o ${outdir}/$(basename $module) \
		    $(find $(dirname $module) -name "$(basename $module)*.c" | tr '\r\n' ' ') $LDFLAGS
		set -e
	done
	rm -f ${build_restart_fn}
}

# A do run run run, a do run run.
do_run()
{
	list_modules | while read module; do
		if [ x${run_restart_fn:-} != x ]; then
			echo ${module} > ${run_restart_fn}
		fi
		echo "-- $(basename $module) --"
		if [ -e ${outdir}/$(basename $module) ] ; then
			RVP_TRACE_FILE="${outdir}/%n.trace" \
		    		${outdir}/$(basename $module) < /dev/null || \
				echo "-- failed --"
		else
			echo "-- not compiled --" ; exit 1
		fi
	done
	rm -f ${run_restart_fn}
}

# Suppress "$ " output, which seems to be caused by "set -i" and "set +i".
PS1=""

set -i
trap_with_reason cleanup_hook EXIT ALRM HUP INT PIPE QUIT TERM
set +i

exitcode=1

prog=$(basename $0)
tmpdir=$(mktemp -d -t ${prog}.XXXXXX)
CC=kcc
skiplist=${tmpdir}/skiplist
COPTS=-pthread
LDFLAGS=-lm
CPPFLAGS="-I C/testcasesupport -D INCLUDEMAIN"
SUPPORT_IO="C/testcasesupport/io.c"
SUPPORT_STD_THREAD="C/testcasesupport/std_thread.c"
outdir=match
selected_cases=thread_cases

[ $# -lt 1 ] && usage
if [ ! -d skiplists ] ; then echo "You need the \"skiplists\" directory here." ; exit 1 ; fi

case ${prog} in
*-predict.sh)
	CC=rvpc
	COPTS="--sigsim=simple"
	outdir=predict
	sort -u skiplists/predict/* | generalize > $skiplist
	build_restart_fn=.predict-last-build
	run_restart_fn=.predict-last-run
	case ${prog} in
	signal-predict.sh)
		export RVP_WINDOW_SIZE=250
		selected_cases=signal_cases
		;;
	thread-predict.sh)
		selected_cases=thread_cases
		#export RVP_OFFLINE_ANALYSIS=yes
		export RVP_TRACE_ONLY=yes
		;;
	*)
		echo "expected \`${prog}\` to match \`thread-predict.sh\` or \`signal-predict.sh\`" 1>&2
		;;
	esac
	;;
match.sh)
	selected_cases=match_cases
	build_restart_fn=.match-last-build
	run_restart_fn=.match-last-run
	sort -u skiplists/match/* | generalize > $skiplist
	;;
*)
	echo "expected \`${prog}\` to match \`*-predict.sh\` or \`match.sh\`" 1>&2
	exit 1
esac

sprtdir="support-${CC}"
SUPPORT_OBJECT_IO="${sprtdir}/io.o"
SUPPORT_OBJECT_STD_THREAD="${sprtdir}/std_thread.o"
json=$(pwd)/${outdir}.json
JSON_REP="-fissue-report=$json"

for cmd in "$@"; do
	if [ ! -d "C" ] && [ ${cmd} != download ] ; then echo "Cannot \"${cmd}\" without the C folder." ; continue ; fi	
	case "${cmd}" in
	reset-build)
		rm -f ${build_restart_fn} ${build_json}
		;;
	reset-run)
                rm -f ${run_restart_fn} ${run_json}
                ;;
	build)
		restart_fn=${build_restart_fn}
		do_build
		;;
	run)
		restart_fn=${run_restart_fn}
		do_run
		;;
	html)
		rv-html-report -o ${outdir}.html ${json}
		;;
	download)
		echo -n "Downloading Juliet Suite..."
        	wget -qq https://samate.nist.gov/SRD/testsuites/juliet/Juliet_Test_Suite_v1.3_for_C_Cpp.zip
        	echo -en "\rUnzipping Juliet Suite..."
        	unzip -qq Juliet_Test_Suite_v1.3_for_C_Cpp.zip
        	echo -e "\rJuliet Suite has arrived."
		;;
	*)
		usage
		;;
	esac
done

if [ ! -d "C" ] ; then echo "No test suite found (C folder). Try \"bash ${prog} download\""; exit 1; fi
exitcode=0

exit 0
