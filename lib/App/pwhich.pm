package App::pwhich;

use strict;
use File::Which ();
use Getopt::Std ();

use vars qw{$VERSION};
BEGIN {
  $VERSION = '1.09';
}
        

sub main
{
  local @ARGV = @_;
  
  # Handle options
  my %opts = ();
  Getopt::Std::getopts('av', \%opts);
  
  if ( $opts{v} ) {
    print <<"END_TEXT";
This is pwhich running File::Which version $File::Which::VERSION

Copyright 2002 Per Einar Ellefsen.

Some parts copyright 2009 Adam Kennedy.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
END_TEXT

    return 2;
  }
  
  unless ( @ARGV ) {
    print <<"END_TEXT";
Usage: $0 [-a] [-v] programname [programname ...]
      -a        Print all matches in PATH, not just the first.
      -v        Prints version and exits

END_TEXT
    return 1;
  }
  
  foreach my $file ( @ARGV ) {
    my @result = $opts{a}
      ? File::Which::which($file)
      # Need to force scalar
      : scalar File::Which::which($file);
    
    # We might end up with @result = (undef) -> 1 elem
    @result = () unless defined $result[0];
    foreach my $result ( @result ) {
      print "$result\n" if $result;
    }
    
    unless ( @result ) {
      print STDERR "pwhich: no $file in PATH\n";
      return 1;
    }

    return 0;
  }
}

1;
