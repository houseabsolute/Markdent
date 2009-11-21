use strict;
use warnings;

use Module::Build;

my $builder = Module::Build->new(
    module_name => 'Markdent',
    license     => 'perl',
    requires    => {
        'Digest::SHA1'                   => '0',
        'HTML::Stream'                   => '0',
        'Moose'                          => '0.92',
        'MooseX::Params::Validate'       => '0.12',
        'MooseX::SemiAffordanceAccessor' => '0.05',
        'MooseX::StrictConstructor'      => '0.08',
        'MooseX::Types'                  => '0.20',
        'namespace::autoclean'           => '0.09',
        'Tree::Simple'                   => '0',
    },
    build_requires => {
        'Test::Deep'        => '0',
        'Test::Differences' => '0',
        'Test::More'        => '0',
    },
    create_readme        => 1,
    sign                 => 1,
    create_makefile_pl   => 'traditional',
    recursive_test_files => 1,
    meta_merge           => {
        resources => {
            bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Markdent',
            repository => 'http://hg.urth.org/hg/Markdent',
        },
    },
);

$builder->create_build_script();
