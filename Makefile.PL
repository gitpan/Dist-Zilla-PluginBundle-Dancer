
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "dzil plugins used by Dancer projects",
  "AUTHOR" => "Yanick Champoux <yanick\@babyl.dyndns.org>",
  "BUILD_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "File::Find" => 0,
    "File::Spec::Functions" => 0,
    "File::Temp" => 0,
    "List::Util" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => 0,
    "warnings" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30",
    "Module::Build" => "0.3601"
  },
  "DISTNAME" => "Dist-Zilla-PluginBundle-Dancer",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Dist::Zilla::PluginBundle::Dancer",
  "PREREQ_PM" => {
    "Dist::Zilla::Plugin::AutoPrereqs" => 0,
    "Dist::Zilla::Plugin::ExecDir" => 0,
    "Dist::Zilla::Plugin::ExtraTests" => 0,
    "Dist::Zilla::Plugin::GatherDir" => 0,
    "Dist::Zilla::Plugin::License" => 0,
    "Dist::Zilla::Plugin::MakeMaker" => 0,
    "Dist::Zilla::Plugin::Manifest" => 0,
    "Dist::Zilla::Plugin::ManifestSkip" => 0,
    "Dist::Zilla::Plugin::MetaJSON" => 0,
    "Dist::Zilla::Plugin::MetaProvides::Package" => 0,
    "Dist::Zilla::Plugin::MetaTests" => 0,
    "Dist::Zilla::Plugin::MetaYAML" => 0,
    "Dist::Zilla::Plugin::ModuleBuild" => 0,
    "Dist::Zilla::Plugin::NoTabsTests" => 0,
    "Dist::Zilla::Plugin::PkgVersion" => 0,
    "Dist::Zilla::Plugin::PodSyntaxTests" => 0,
    "Dist::Zilla::Plugin::PodWeaver" => 0,
    "Dist::Zilla::Plugin::PruneCruft" => 0,
    "Dist::Zilla::Plugin::Test::Compile" => 0,
    "Dist::Zilla::Plugin::Test::ReportPrereqs" => 0,
    "Dist::Zilla::Role::PluginBundle::Easy" => 0,
    "Moose" => 0,
    "strict" => 0
  },
  "VERSION" => "0.0004",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



