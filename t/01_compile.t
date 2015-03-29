use 5.005003;
use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 1;

use_ok( 'File::Which' );
