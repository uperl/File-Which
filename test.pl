# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

use Test;
BEGIN { plan tests => 9 };
use File::Which;
ok(1);
import File::Which qw(where);
ok(ref(\&where), 'CODE');

# check that it returns undef if no file is passed
ok(which(''), undef);

ok(which('perl'), qr|\Q$^X|i);    # apparently $^X isn't guaranteed to be under path or anything.. let's just pray it works :)

ok(which('non_existent_very_unlinkely_thingy_executable'), undef);
ok(-x which('perl'), 1);

my @result = which('perl', { all => 1 });
ok($result[0], qr|\Q$^X|i);    # tests $opt->{all}
ok(@result > 0, 1);
ok(@result, scalar where('perl')); # should have as many elements.

