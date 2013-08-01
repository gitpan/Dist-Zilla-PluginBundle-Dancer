package Dist::Zilla::PluginBundle::Dancer;
BEGIN {
  $Dist::Zilla::PluginBundle::Dancer::AUTHORITY = 'cpan:YANICK';
}
{
  $Dist::Zilla::PluginBundle::Dancer::VERSION = '0.0006';
}

# ABSTRACT: dzil plugins used by Dancer projects


use 5.10.0;

use strict;

use Moose;

use Dist::Zilla::Plugin::GatherDir;
use Dist::Zilla::Plugin::Test::Compile 2.011;
use Dist::Zilla::Plugin::MetaTests;
use Dist::Zilla::Plugin::NoTabsTests;
use Dist::Zilla::Plugin::PodSyntaxTests;
use Dist::Zilla::Plugin::ExtraTests;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::PruneCruft;
use Dist::Zilla::Plugin::ManifestSkip;
use Dist::Zilla::Plugin::ExecDir;
use Dist::Zilla::Plugin::AutoPrereqs;
use Dist::Zilla::Plugin::PkgVersion;
use Dist::Zilla::Plugin::MetaProvides::Package;
use Dist::Zilla::Plugin::License;
use Dist::Zilla::Plugin::MakeMaker;
use Dist::Zilla::Plugin::ModuleBuild;
use Dist::Zilla::Plugin::MetaYAML;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::Manifest;
use Dist::Zilla::Plugin::Test::ReportPrereqs;
use Dist::Zilla::Plugin::UploadToCPAN;
use Dist::Zilla::Plugin::Authority;

with 'Dist::Zilla::Role::PluginBundle::Easy';

has authority => (
    is      => 'ro',
    isa     => 'Maybe[Str]',
    lazy    => 1,
    default => sub { $_[0]->payload->{authority} },
);

has test_compile_skip => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    lazy => 1,
    default => sub {
        return [ 
            ( $_[0]->payload->{test_compile_skip} )
                x !! $_[0]->payload->{test_compile_skip}
        ];
    },
);

has include_dotfiles => (
    is => 'ro',
    isa => 'Bool',
    lazy => 1,
    default => sub {
        $_[0]->payload->{include_dotfiles} // 1;
    },
);

sub configure {
    my ( $self ) = @_;
    my $arg = $self->payload;

    $self->add_plugins(
        [ 'GatherDir' => { 
                include_dotfiles => $self->include_dotfiles
            },
        ],
        [ 'Test::Compile' => { skip => $self->test_compile_skip } ],
        qw/ 
            MetaTests
            NoTabsTests
            PodSyntaxTests
            ExtraTests
            Test::ReportPrereqs
            PodWeaver
            PruneCruft
            ManifestSkip
            ExecDir
        /,
        [ 'AutoPrereqs' => { 
                ( skip => $arg->{autoprereqs_skip} )x!!$arg->{autoprereqs_skip} 
        } ],
        'MetaProvides::Package',
        'PkgVersion',
    );

    if ( my $authority = $self->authority ) {
        $self->add_plugins(
            [ 'Authority' => { authority => $authority } ],
        );
    }

    $self->add_plugins(
        qw/
            License
            MakeMaker
            ModuleBuild
            MetaYAML
            MetaJSON
            Manifest
            UploadToCPAN
        /,
    );

    return;
}

1;

__END__

=pod

=head1 NAME

Dist::Zilla::PluginBundle::Dancer - dzil plugins used by Dancer projects

=head1 VERSION

version 0.0006

=head1 DESCRIPTION

This is the plugin bundle that the core L<Dancer> crew use to release
their distributions. It's roughly equivalent to

    [GatherDir]
    [PruneCruft]
    [ManifestSkip]
    [ExecDir]

    [AutoPrereqs]
    [MetaProvides::Package]
    [License]
    [MakeMaker]
    [ModuleBuild]
    [MetaYAML]
    [MetaJSON]
    [Manifest]

    [PkgVersion]

    [Authority]

    [Test::Compile]
    [MetaTests]
    [NoTabTests]
    [PodSyntaxTests]
    [Test::ReportPrereqs]

    [PodWeaver]

    [UploadToCPAN]

=head2 ARGUMENTS

=head3 authority

For L<Dist::Zilla::Plugin::Authority>. If not given,
L<Dist::Zilla::Plugin::Authority> will not be used.

=head3 test_compile_skip

I<skip> option for L<Dist::Zilla::Plugin::Test::Compile>.

=head3 autoprereqs_skip

I<skip> option for L<Dist::Zilla::Plugin::AutoPrereqs>.

=head3 include_dotfiles

For L<Dist::Zilla::Plugin::GatherDir>. Defaults to I<1>.

=head1 AUTHOR

Yanick Champoux <yanick@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
