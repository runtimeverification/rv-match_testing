#! /usr/bin/env perl

# Obtained from Chris Hathhorn
# March 28 2018
#   categorize.sh
#   fetch.sh
# > juliet.pl
#   runner.pl

use strict;
use Time::HiRes qw(gettimeofday tv_interval);
use File::Basename;

my $childPid = 0;

# first argument is a flag, -p or -f for shouldPass or shouldFail
# second argument is a directory to test
my $numArgs = $#ARGV + 1;
if ($numArgs != 2) {
      die "Not enough command line arguments"
}

my $command = $ARGV[0];
my $test = $ARGV[1];

unlink "juliet.out";
if (-e "juliet.out") {
      print "(fail)";
      exit 1;
}

my ($signal, $retval, $output, $stderr);

($signal, $retval, $output, $stderr) = run("$command -o juliet.out -fno-native-compilation -I juliet/C/testcasesupport -D INCLUDEMAIN juliet/C/testcasesupport/io.o $test");

# print "$output\n$stderr";
if ($signal) {
      print "signal ($signal)";
      exit 1;
}
if ($retval) {
      print "$retval";
      exit 2;
}

if ($stderr =~ m/Undefined behavior \((.*?)\)/) {
      print "$1 (static)";
      exit 0;
}

($signal, $retval, $output, $stderr) = run("./juliet.out");

if ($stderr =~ m/Undefined behavior \((.*?)\)/) {
      print "$1";
      exit 0;
}

print "(no errors)";
exit 6;

sub run {
      my ($theircommand) = (@_);

      my $command = "stdbuf -o0 -e0 $theircommand 1>stdout_tool.txt 2>stderr_tool.txt";
      # print "Running $command\n";
      $childPid = open P, "$command |" or die "Error running \"$command\"!";
      #my @data=<P>;
      close P;
      # my $retval = $? >> 8;
      my $retval = 0;
      if ($? == -1) {
            # print "failed to execute: $!\n";
            $retval = -1;
      } else {
            # printf "child exited with value %d\n", $? >> 8;
            $retval = $? >> 8;
      }
      my $signal = ($? & 127);

      open FILE, "stdout_tool.txt" or die "Couldn't open file: $!"; 
      my $stdout = join("", <FILE>); 
      close FILE;
      open FILE, "stderr_tool.txt" or die "Couldn't open file: $!"; 
      my $stderr = join("", <FILE>); 
      close FILE;

      $childPid = 0;
      return ($signal, $retval, $stdout, $stderr);
}
