#!/usr/bin/perl

# Check the pwhich script by confirming it matches the function result

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 10;
use Test::Script;
use File::Which;

# Look for a very common program
my $tool = 'perl2';
my $path = which($tool);
ok( defined $path, "Found path to $tool" );
ok( $path, "Found path to $tool" );
ok( -f $path, "$tool exists" );

# Can we find the tool with the command line version?
script_runs(
	[ 'script/pwhich', 'perl' ],
	'Found perl with pwhich',
);
