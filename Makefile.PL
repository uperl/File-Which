use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'File::Which',
    'VERSION_FROM'	=> 'Which.pm', # finds $VERSION
    'PREREQ_PM'		=> {
                'File::Spec' => 0.60,     # The version coming with perl-5.005_03
      },
    'EXE_FILES' => ['bin/pwhich'],
      ($] >= 5.005 ?   
      (ABSTRACT_FROM => 'Which.pm', # retrieve abstract from module
       AUTHOR     => 'Per Einar Ellefsen <per.einar (at) skynet.be>') : ()),
);
