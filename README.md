# File::Which

Perl implementation of the which utility as an API

# SYNOPSIS

    use File::Which;                  # exports which()
    use File::Which qw(which where);  # exports which() and where()
    
    my $exe_path = which 'perldoc';
    
    my @paths = where 'perl';
    # Or
    my @paths = which 'perl'; # an array forces search for all of them

# DESCRIPTION

[File::Which](https://metacpan.org/pod/File::Which) finds the full or relative paths to executable programs on
the system.  This is normally the function of `which` utility.  `which` is
typically implemented as either a program or a built in shell command.  On
some platforms, such as Microsoft Windows it is not provided as part of the
core operating system.  This module provides a consistent API to this
functionality regardless of the underlying platform.

The focus of this module is correctness and portability.  As a consequence
platforms where the current directory is implicitly part of the search path
such as Microsoft Windows will find executables in the current directory,
whereas on platforms such as UNIX where this is not the case executables 
in the current directory will only be found if the current directory is
explicitly added to the path.

If you need a portable `which` on the command line in an environment that
does not provide it, install [App::pwhich](https://metacpan.org/pod/App::pwhich) which provides a command line
interface to this API.

## Implementations

[File::Which](https://metacpan.org/pod/File::Which) searches the directories of the user's `PATH` (the current
implementation uses [File::Spec#path](https://metacpan.org/pod/File::Spec#path) to determine the correct `PATH`),
looking for executable files having the name specified as a parameter to
["which"](#which). Under Win32 systems, which do not have a notion of directly
executable files, but uses special extensions such as `.exe` and `.bat`
to identify them, `File::Which` takes extra steps to assure that
you will find the correct file (so for example, you might be searching for
`perl`, it'll try `perl.exe`, `perl.bat`, etc.)

### Linux, \*BSD and other UNIXes

There should not be any surprises here.  The current directory will not be
searched unless it is explicitly added to the path.

### Modern Windows (including NT, XP, Vista, 7, 8, 10 etc)

Windows NT has a special environment variable called `PATHEXT`, which is used
by the shell to look for executable files. Usually, it will contain a list in
the form `.EXE;.BAT;.COM;.JS;.VBS` etc. If `File::Which` finds such an
environment variable, it parses the list and uses it as the different
extensions.

### Windows 95, 98, ME, MS-DOS, OS/2

This set of operating systems don't have the `PATHEXT` variable, and usually
you will find executable files there with the extensions `.exe`, `.bat` and
(less likely) `.com`. `File::Which` uses this hardcoded list if it's running
under Win32 but does not find a `PATHEXT` variable.

As of 2015 none of these platforms are tested frequently (or perhaps ever),
but the current maintainer is determined not to intentionally remove support
for older operating systems.

### VMS

Same case as Windows 9x: uses `.exe` and `.com` (in that order).

As of 2015 the current maintainer does not test on VMS, and is in fact not
certain it has ever been tested on VMS.  If this platform is important to you
and you can help me verify and or support it on that platform please contact
me.

# FUNCTIONS

## which

    my $path = which $short_exe_name;
    my @paths = which $short_exe_name;

Exported by default.

`$short_exe_name` is the name used in the shell to call the program (for
example, `perl`).

If it finds an executable with the name you specified, `which()` will return
the absolute path leading to this executable (for example, `/usr/bin/perl` or
`C:\Perl\Bin\perl.exe`).

If it does _not_ find the executable, it returns `undef`.

If `which()` is called in list context, it will return _all_ the
matches.

## where

    my @paths = where $short_exe_name;

Not exported by default.

Same as ["which"](#which) in array context. Same as the
`where` utility, will return an array containing all the path names
matching `$short_exe_name`.

# CAVEATS

Not tested on VMS although there is platform specific code
for those. Anyone who haves a second would be very kind to send me a
report of how it went.

# SUPPORT

Bugs should be reported via the GitHub issue tracker

[https://github.com/plicease/File-Which/issues](https://github.com/plicease/File-Which/issues)

For other issues, contact the maintainer.

# SEE ALSO

- [pwhich](https://metacpan.org/pod/pwhich)

    Command line interface to this module.

- [IPC::Cmd](https://metacpan.org/pod/IPC::Cmd)

    Comes with a `can_run` function with slightly different semantics that
    the traditional UNIX where.  It will find executables in the current
    directory, even though the current directory is not searched for by
    default on Unix.

- [Devel::CheckBin](https://metacpan.org/pod/Devel::CheckBin)

    This module purports to "check that a command is available", but does not
    provide any documentation on how you might use it.

# AUTHORS

- Per Einar Ellefsen <pereinar@cpan.org>
- Adam Kennedy <adamk@cpan.org>
- Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2002 by Per Einar Ellefsen <pereinar@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
