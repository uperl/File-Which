package File::Which;

use strict;

use vars qw(@ISA @EXPORT $VERSION);

require Exporter;

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

@EXPORT = qw(which);

$VERSION = '0.01';

use File::Spec;
use constant IS_WIN32 => $^O eq 'MSWin32';


my @path_ext = ('');        # For Win32 systems, stores the extensions used for
                            # executable files
                            # For others, the empty string is used because 'perl' . '' eq 'perl' => easier
if (IS_WIN32) {
    if ($ENV{PATHEXT}) {    # WinNT
        push @path_ext, split ';', $ENV{PATHEXT};
    }
    else {
        push @path_ext, map { ".$_" } qw(com exe bat); # Win9X: doesn't have PATHEXT, so needs hardcoded.
    }
}
sub which {
    for my $base (map { File::Spec->catfile($_, $_[0]) } File::Spec->path()) {
        for my $ext (@path_ext) {
            return $base.$ext if -x $base.$ext;
        }
    }
    return '';
}

1;
__END__

=head1 NAME

File::Which - Portable implementation of the `which' utility

=head1 SYNOPSIS

  use File::Which;
  
  my $exe_path = which('perldoc');

=head1 DESCRIPTION

C<File::Which> was created to be able to get the paths to executable programs
on systems under which the `which' program wasn't implemented in the shell.

C<File::Which> searches the directories of the user's C<PATH> (as returned by
C<File::Spec->path()>), looking for executable files having the name specified
as a parameter to C<which()>. Under Win32 systems, which do not have a notion of
directly executable files, but uses special extensions such as C<.exe> and
C<.bat> to identify them, C<File::Which> takes extra steps to assure that you
will find the correct file (so for example, you might be searching for C<perl>,
it'll try C<perl.exe>, C<perl.bat>, etc.)

=head2 STEPS USED ON WIN32

=over 4

=item * Windows NT

Windows NT has a special environment variable called C<PATHEXT>, which is used
by the shell to look for executable files. Usually, it will contain a list in
the form C<.EXE;.BAT;.COM;.JS;.VBS> etc. If C<File::Which> finds such an
environment variable, it parses the list and uses it as the different extensions.

=item * Windows 9x

This set of operating systems don't have the C<PATHEXT> variable, and usually
you will find executable files there with the extensions C<.exe>, C<.bat> and
(less likely) C<.com>. C<File::Which> uses this hardcoded list if it's running
under Win32 but does not find a C<PATHEXT> variable.

=back

=head2 EXPORT

=over 4

=item * which($short_exe_name)

Exported by default.

C<$short_exe_name> is the name used in the shell to call the program (for
example, C<perl>).

If it finds an executable with the name you specified, C<which()> will return
the absolute path leading to this executable (for example, C</usr/bin/perl> or
C<C:\Perl\Bin\perl.exe>).

if it does I<not> find the executable, it returns the empty string.

=back

=head1 AUTHOR

Per Einar Ellefsen, E<lt>per.einar (at) skynet.beE<gt>

Originated in I<modperl-2.0/lib/Apache/Build.pm>. Changed for use in DocSet
(for the mod_perl site) and Win32-awareness by me, with slight modifications
by Stas Bekman, then extracted to create C<File::Which>.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<File::Spec>.

=cut
