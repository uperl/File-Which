# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test;
BEGIN { plan tests => 2 };
use File::Which;
ok(1);

ok(which('perl'), qr/perl/);    # I would use $0, but apparently it's not guaranteed
                                # to be an absolute path etc etc etc...
