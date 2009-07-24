#!/usr/bin/perl

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 9;
use File::Spec  ();
use File::Which ();

use constant IS_VMS    => ($^O eq 'VMS');
use constant IS_MAC    => ($^O eq 'MacOS');
use constant IS_DOS    => ($^O eq 'MSWin32' or $^O eq 'dos' or $^O eq 'os2');
use constant IS_CYGWIN => ($^O eq 'cygwin');

# Check that it returns undef if no file is passed
is(
	scalar(which('')), undef,
	'Null-length false result' );

is(
	scalar(which('non_existent_very_unlinkely_thingy_executable')), undef,
	'Positive length false result',
);

# Where is the test application
my $test_bin = File::Spec->catdir( 't', 'test-bin' );
ok( -d $test_bin, 'Found test-bin' );

# Set up for running the test application
local $ENV{PATH} = $test_bin;
unless (
	File::Which::IS_VMS
	or
	File::Which::IS_MAC
	or
	File::Which::IS_DOS
) {
	my $test3 = File::Spec->catfile( $test_bin, 'test3' );
	chmod 0755, $test3;
}

SKIP: {
	skip("Not on DOS-like filesystem", 3) unless IS_DOS;
	is( lc scalar which('test1'), 't\test-bin\test1.exe', 'Looking for test1.exe' );
	is( lc scalar which('test2'), 't\test-bin\test1.bat', 'Looking for test2.bat' );
	is( scalar which('test3'), undef, 'test3 returns undef );
}



    # testing Unix finally:
  $skip = 1 if $Is_DOSish or $Is_MacOS or $Is_VMS;
  skip($skip, scalar which('test3'), 'test-bin/test3', 'Check test3 for Unix');
  
  $skip = 0;
  # Cygwin: should make test1.exe transparent
  $skip = 1 unless $Is_Cygwin;
  skip($skip, scalar which('test1'), 'test-bin/test1', 'Looking for test1 on Cygwin: transparent to test1.exe');

  ok(scalar which('test4'), undef, 'Make sure that which() doesn\'t return a directory');

  chdir 'test-bin';
  
  $skip = 0;
  
  # Make sure that .\ stuff works on DOSish, VMS, MacOS (. is in PATH implicitly).
  $skip = 1 unless $Is_DOSish or $Is_VMS; # or $Is_MacOS; # no idea
                                          # how binaries should look
                                          # like on Mac
  skip($skip, lc scalar which('test1'),
       File::Spec->catfile(File::Spec->curdir(), 'test1.exe'),
       'Looking for test1.exe in curdir'
  );
  
}
