
use Test;
BEGIN { plan tests => 3 };
use File::Which qw(which where);

my @result = which('perl');

ok($result[0], qr/perl/i);
ok(@result > 0, 1);
ok(scalar @result, scalar where('perl')); # should have as many elements.
