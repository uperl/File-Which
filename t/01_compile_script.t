use 5.005003;
use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More;

BEGIN {
  plan skip_all => 'test requires Test::Script' unless eval q{ use Test::Script; 1 };
}

plan tests => 1;

script_compiles('script/pwhich');
