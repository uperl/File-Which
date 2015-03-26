# Check the pwhich script by confirming it matches the function result

use 5.005003;
use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 1;
use Test::Script;
use File::Which;

# Can we find the tool with the command line version?
script_runs(
	[ 'script/pwhich', 'perl' ],
	'Found perl with pwhich',
);
