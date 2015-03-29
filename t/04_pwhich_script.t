# Check the pwhich script by confirming it matches the function result

use 5.005003;
use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More;
use Test::Script;
use File::Which;

BEGIN {
  plan skip_all => 'test requires Test::Script' unless eval q{ use Test::Script 1.05; 1 };
}

plan tests => 1;
# Can we find the tool with the command line version?
script_runs(
	[ 'script/pwhich', 'perl' ],
	'Found perl with pwhich',
);
