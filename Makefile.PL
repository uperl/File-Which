use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'File::Which',
    'VERSION_FROM'	=> 'Which.pm', # finds $VERSION
    'PREREQ_PM'		=> {
                File::Spec => undef
      },
      ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'Which.pm', # retrieve abstract from module
       AUTHOR     => 'Per Einar Ellefsen <per.einar (at) skynet.be>') : ()),
);
