use Test;
BEGIN { plan tests => 4 };
use File::Which;

# check that it returns undef if no file is passed
ok(scalar which(''), undef);

ok(which('perl'), qr/perl/i);

ok(scalar which('non_existent_very_unlinkely_thingy_executable'), undef);

my $skip = 0;
$skip = 1 if ($^O eq 'MacOS');
skip($skip, -x (scalar which('perl')), 1);
