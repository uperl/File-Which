package File::Which;

use strict;

use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw(which);
@EXPORT_OK = qw(where);

$VERSION = '0.02';

use File::Spec;
use File::HomeDir;          # exports home()
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
    my ($exec, $opt) = @_;

    return undef unless $exec;

    my @results = ();
    
    for my $base (map { File::Spec->catfile($_, $exec) } File::Spec->path()) {

        $base =~ s/~/home()/e;                  # Must eliminate ~, as File::Spec doesn't expand it.

        for my $ext (@path_ext) {
            my $file = $base.$ext;
            if(-x $file) {
                unless($opt->{all}) {           # Normal case
                    return $file;
                } else {
                    push @results, $file;       # Make list to return later
                }
            }
        }
    }
    
    if($opt->{all}) {
        return @results;
    } else {
        return undef;
    }
}

sub where {
    which($_[0], { all => 1 });
}

1;
__END__

=head1 NAME

File::Which - Portable implementation of the `which' utility

=head1 SYNOPSIS

  use File::Which;      # exports which()
  use File::Which qw(which where);  # exports which() and where()
  
  my $exe_path = which('perldoc');
  
  my @paths = where('perl');
  - Or -
  my @paths = which('perl', {all => 1 });

=head1 DESCRIPTION

C<File::Which> was created to be able to get the paths to executable programs
on systems under which the `which' program wasn't implemented in the shell.

C<File::Which> searches the directories of the user's C<PATH> (as returned by
C<File::Spec-E<gt>path()>), looking for executable files having the name specified
as a parameter to C<which()>. Under Win32 systems, which do not have a notion of
directly executable files, but uses special extensions such as C<.exe> and
C<.bat> to identify them, C<File::Which> takes extra steps to assure that you
will find the correct file (so for example, you might be searching for C<perl>,
it'll try C<perl.exe>, C<perl.bat>, etc.)

=head1 STEPS USED ON WIN32

=head2 Windows NT

Windows NT has a special environment variable called C<PATHEXT>, which is used
by the shell to look for executable files. Usually, it will contain a list in
the form C<.EXE;.BAT;.COM;.JS;.VBS> etc. If C<File::Which> finds such an
environment variable, it parses the list and uses it as the different extensions.

=head2 Windows 9x

This set of operating systems don't have the C<PATHEXT> variable, and usually
you will find executable files there with the extensions C<.exe>, C<.bat> and
(less likely) C<.com>. C<File::Which> uses this hardcoded list if it's running
under Win32 but does not find a C<PATHEXT> variable.


=head1 FUNCTIONS

=head2 which($short_exe_name, \%opt)

Exported by default.

C<$short_exe_name> is the name used in the shell to call the program (for
example, C<perl>).

If it finds an executable with the name you specified, C<which()> will return
the absolute path leading to this executable (for example, C</usr/bin/perl> or
C<C:\Perl\Bin\perl.exe>).

if it does I<not> find the executable, it returns the empty string.

C<which()> also accepts a hash reference with options: 

=over 4

=item *

B<all>: if set to 1, C<which()> will return a list of all the executable paths
it finds, and not just the first match. See C<where()>.

=back

=head2 where($short_exe_name)

Not exported by default.

Same as C<which($short_exe_name, { all =E<gt> 1 })>. Same as the C<`where'> utility,
will return an array containing all the path names matching C<$short_exe_name>.


=head1 BUGS

Has not been tested under MacOS. If anyone could give me the information needed
for it to work on the Mac (how it searches the path, etc... although MacOs E<lt>
X don't have a shell, so this might not really apply).

=head1 AUTHOR

Per Einar Ellefsen, E<lt>per.einar (at) skynet.beE<gt>

Originated in I<modperl-2.0/lib/Apache/Build.pm>. Changed for use in DocSet
(for the mod_perl site) and Win32-awareness by me, with slight modifications
by Stas Bekman, then extracted to create C<File::Which>.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 SEE ALSO

L<File::Spec>, L<File::HomeDir>.

=cut
