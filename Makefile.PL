use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

(do 'maint/Makefile.PL.include' or die $@) unless -f 'META.yml';

WriteMakefile(
  NAME => 'MooX::Aliases',
  VERSION_FROM => 'lib/MooX/Aliases.pm',

  PREREQ_PM => {
    'Moo' => 1.001000,
    'Class::Method::Modifiers' => 1.05,
    'strictures' => 1,
  },
  'BUILD_REQUIRES' => {
    'Test::More' => 0.94,
    'Test::Fatal' => 0,
  },

  META_MERGE => {
    requires => {
      perl => 5.008001,
    },
    dynamic_config => 0,
    resources => {
      repository => 'git://github.com/haarg/MooX-Aliases.git',
      homepage => 'http://github.com/haarg/MooX-Aliases',
    },
  },
);
