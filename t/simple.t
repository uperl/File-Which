use Test;
BEGIN { plan tests => 9; }
use File::Which;
use File::Spec;

# check that it returns undef if no file is passed
ok(scalar which(''), undef);

ok(scalar which('non_existent_very_unlinkely_thingy_executable'), undef);

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
  
  unless ($Is_VMS or $Is_MacOS or $Is_DOSish) { # dunno about VMS, think not
      chmod 0755, "test-bin/test3";
  }
  
  my $skip = 0;
  # test1.exe
  $skip = 1 unless $Is_DOSish;
  skip($skip, lc scalar which('test1'), 'test-bin\test1.exe', 'Looking for test1.exe');
  
  # test2.bat
  skip($skip, lc scalar which('test2'), 'test-bin\test2.bat', 'Looking for test2.bat');
  
  # Make sure that test3 isn't returned by File::Which on DOSish. (it is in
  # PATH, but is a normal file on DOSish)
  skip($skip, scalar which('test3'), undef);
  
  $skip = 0;
  
    # testing Unix finally:
  $skip = 1 if $Is_DOSish or $Is_MacOS or $Is_VMS;
  skip($skip, scalar which('test3'), 'test-bin/test3', 'Check test3 for Unix');
  
  $skip = 0;
  # Cygwin: should make test1.exe transparent
  $skip = 1 unless $Is_Cygwin;
  skip($skip, scalar which('test1'), 'test-bin/test1', 'Looking for test1 on Cygwin: transparent to test1.exe');

  ok(scalar which('test4'), undef, 'Make sure that which() doesn\'t return a directory');

  chdir 'test-bin';
  
  $skip = 0;
  
  # Make sure that .\ stuff works on DOSish, VMS, MacOS (. is in PATH implicitly).
  $skip = 1 unless $Is_DOSish or $Is_VMS; # or $Is_MacOS; # no idea
                                          # how binaries should look
                                          # like on Mac
  skip($skip, lc scalar which('test1'),
       File::Spec->catfile(File::Spec->curdir(), 'test1.exe'),
       'Looking for test1.exe in curdir'
  );
  
}
