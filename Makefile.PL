use 5.004;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'         => 'File::Which',
	'ABSTRACT'     => 'Portable implementation of the "which" utility',
	'VERSION_FROM' => 'lib/File/Which.pm',
	'PREREQ_PM'    => {
		'Exporter'    => 0,
		'Getopt::Std' => 0,
		'File::Spec'  => '0.60',
		'Test::More'  => '0.80',
	},
	'EXE_FILES' => [
		'script/pwhich',
	],
	( $] >= 5.005 ? (
		ABSTRACT_FROM => 'lib/File/Which.pm', # retrieve abstract from module
		AUTHOR        => 'Adam Kennedy <adamk@cpan.org>',
	) : () ),
	( $ExtUtils::MakeMaker::VERSION ge '6.31' ? (
		LICENSE => 'perl',
	) : () ),
);
