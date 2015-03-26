use 5.005003;
use strict;
use ExtUtils::MakeMaker;

my @exe_files = ('script/pwhich');

if(eval q{ use App::pwhich 1.14; 1 })
{
  @exe_files = ();
}

WriteMakefile(
	'NAME'         => 'File::Which',
	'ABSTRACT'     => 'Portable implementation of the "which" utility',
	'VERSION_FROM' => 'lib/File/Which.pm',
	( $ExtUtils::MakeMaker::VERSION ge '6.48' ? (
	        'MIN_PERL_VERSION' => '5.005003',
	) : () ),
	'PREREQ_PM'    => {
		'Exporter'     => 0,
		'Getopt::Std'  => 0,
		'File::Spec'   => '0.60',
		($ExtUtils::MakeMaker::VERSION lt '6.34' ? (
			'Test::More'   => '0.80',
		) : () ),
	},
	($ExtUtils::MakeMaker::VERSION ge '6.34' ? (
		TEST_REQUIRES => {
			'Test::More'   => '0.80',
		},
	) : () ),
	'EXE_FILES' => \@exe_files,
	( $] >= 5.005 ? (
		AUTHOR => 'Adam Kennedy <adamk@cpan.org>',
	) : () ),
	( $ExtUtils::MakeMaker::VERSION ge '6.31' ? (
		LICENSE => 'perl',
	) : () ),

	( $ExtUtils::MakeMaker::VERSION ge '6.46' ? (
		META_MERGE => {
			'meta-spec' => { version => 2 },
			dynamic_config => 0,
			resources => {
				bugtracker => {
					web => 'https://github.com/plicease/File-Which/issues',
				},
				homepage => 'https://metacpan.org/pod/File::Which',
				repository => {
					type => 'git',
					url  => 'https://github.com/plicease/File-Which.git',
					web  => 'https://github.com/plicease/File-Which',
				},
			},
		},
	) : () ),

);
