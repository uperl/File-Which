
use Test;
BEGIN { plan tests => 3 }
use File::Which qw(which where);

# So let's try using test-bin, huh?

my $Is_VMS    = ($^O eq 'VMS');
my $Is_MacOS  = ($^O eq 'MacOS');
my $Is_DOSish = (($^O eq 'MSWin32') or
                ($^O eq 'dos')     or
                ($^O eq 'os2'));
my $Is_Cygwin = $^O eq 'cygwin';

{
  chdir 't' if (-d 't');
  local $ENV{PATH} = 'test-bin';
  
  if (not ($Is_VMS or $Is_MacOS or $Is_DOSish)) { # dunno about VMS
      chmod 0755, "test-bin/all";
  }

  my @result = which('all');
  ok($result[0], qr/all/i);
  ok(@result > 0, 1);
  ok(scalar @result, scalar where('all')); # should have as many elements.

}
