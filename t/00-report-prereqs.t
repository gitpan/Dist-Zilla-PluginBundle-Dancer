#!perl

use strict;
use warnings;

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use List::Util qw/max/;

my @modules = qw(
  Dist::Zilla::Plugin::Authority
  Dist::Zilla::Plugin::AutoPrereqs
  Dist::Zilla::Plugin::ExecDir
  Dist::Zilla::Plugin::ExtraTests
  Dist::Zilla::Plugin::GatherDir
  Dist::Zilla::Plugin::License
  Dist::Zilla::Plugin::MakeMaker
  Dist::Zilla::Plugin::Manifest
  Dist::Zilla::Plugin::ManifestSkip
  Dist::Zilla::Plugin::MetaJSON
  Dist::Zilla::Plugin::MetaProvides::Package
  Dist::Zilla::Plugin::MetaTests
  Dist::Zilla::Plugin::MetaYAML
  Dist::Zilla::Plugin::ModuleBuild
  Dist::Zilla::Plugin::NoTabsTests
  Dist::Zilla::Plugin::PkgVersion
  Dist::Zilla::Plugin::PodSyntaxTests
  Dist::Zilla::Plugin::PodWeaver
  Dist::Zilla::Plugin::PruneCruft
  Dist::Zilla::Plugin::Test::Compile
  Dist::Zilla::Plugin::Test::ReportPrereqs
  Dist::Zilla::Plugin::UploadToCPAN
  Dist::Zilla::Role::PluginBundle::Easy
  ExtUtils::MakeMaker
  File::Spec
  File::Spec::Functions
  IO::Handle
  IPC::Open3
  List::Util
  Module::Build
  Moose
  Test::More
  perl
  strict
  warnings
);

# replace modules with dynamic results from MYMETA.json if we can
# (hide CPAN::Meta from prereq scanner)
my $cpan_meta = "CPAN::Meta";
if ( -f "MYMETA.json" && eval "require $cpan_meta" ) { ## no critic
  if ( my $meta = eval { CPAN::Meta->load_file("MYMETA.json") } ) {
    my $prereqs = $meta->prereqs;
    delete $prereqs->{develop};
    my %uniq = map {$_ => 1} map { keys %$_ } map { values %$_ } values %$prereqs;
    $uniq{$_} = 1 for @modules; # don't lose any static ones
    @modules = sort keys %uniq;
  }
}

my @reports = [qw/Version Module/];

for my $mod ( @modules ) {
  next if $mod eq 'perl';
  my $file = $mod;
  $file =~ s{::}{/}g;
  $file .= ".pm";
  my ($prefix) = grep { -e catfile($_, $file) } @INC;
  if ( $prefix ) {
    my $ver = MM->parse_version( catfile($prefix, $file) );
    $ver = "undef" unless defined $ver; # Newer MM should do this anyway
    push @reports, [$ver, $mod];
  }
  else {
    push @reports, ["missing", $mod];
  }
}

if ( @reports ) {
  my $vl = max map { length $_->[0] } @reports;
  my $ml = max map { length $_->[1] } @reports;
  splice @reports, 1, 0, ["-" x $vl, "-" x $ml];
  diag "Prerequisite Report:\n", map {sprintf("  %*s %*s\n",$vl,$_->[0],-$ml,$_->[1])} @reports;
}

pass;

# vim: ts=2 sts=2 sw=2 et:
