package App::pwhich;

use strict;
use File::Which ();
use Getopt::Std ();

use vars qw{$VERSION};
BEGIN {
  $VERSION = '1.11';
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
  }
  
  return 0;
}

1;

__END__

=pod

=head1 NAME

App::pwhich - Portable implementation of the `which' utility

=head1 DESCRIPTION

This module contains the guts of the L<pwhich> script that is
currently bundled with L<File::Which>.  It will be spun off
into its own distribution soon, so if you require L<pwhich>,
as a prerequisite, please use L<App::pwhich> as a prerequisite
instead of L<File::Which>.

=head1 SUPPORT

Bugs should be reported via the GitHub issue tracker

L<https://github.com/plicease/File-Which/issues>

For other issues, contact the maintainer.

=head1 SEE ALSO

=over 4

=item L<pwhich>

Publich interface (script) for this module.

=item L<File::Which>

Implementation used by this module.

=item L<Devel::CheckBin>

This module purports to "check that a command is available", but does not
provide any documentation on how you might use it.

=back

=head1 AUTHOR

Current maintainer: Graham Ollis E<lt>plicease@cpan.orgE<gt>

Previous maintainer: Adam Kennedy E<lt>adamk@cpan.orgE<gt>

Original author: Per Einar Ellefsen E<lt>pereinar@cpan.orgE<gt>

Originated in F<modperl-2.0/lib/Apache/Build.pm>. Changed for use in DocSet
(for the mod_perl site) and Win32-awareness by me, with slight modifications
by Stas Bekman, then extracted to create C<File::Which>.

Version 0.04 had some significant platform-related changes, taken from
the Perl Power Tools C<`which'> implementation by Abigail with
enhancements from Peter Prymmer. See
L<http://www.perl.com/language/ppt/src/which/index.html> for more
information.

=head1 COPYRIGHT

Copyright 2002 Per Einar Ellefsen.

Some parts copyright 2009 Adam Kennedy.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<File::Spec>, L<which(1)>, Perl Power Tools:
L<http://www.perl.com/language/ppt/index.html>.

=cut
