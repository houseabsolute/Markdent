use strict;
use warnings;

use lib 'inc';

use Markdent::Build;

my $builder = Markdent::Build->new(
    module_name => 'Markdent',
    license     => 'perl',
    requires    => {
        'Digest::SHA1'                   => '0',
        'HTML::Stream'                   => '0',
        'List::AllUtils'                 => '0',
        'Moose'                          => '0.92',
        'MooseX::Params::Validate'       => '0.12',
        'MooseX::SemiAffordanceAccessor' => '0.05',
        'MooseX::StrictConstructor'      => '0.08',
        'MooseX::Types'                  => '0.20',
        'namespace::autoclean'           => '0.09',
        'Tree::Simple'                   => '0',
    },
    build_requires => {
        'File::Slurp'                          => '0',
        'Test::Deep'                           => '0',
        'Test::Differences'                    => '0',
        'Test::More'                           => '0',
        'Tree::Simple::Visitor::ToNestedArray' => '0',
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
    add_to_cleanup => ['Debian_CPANTS.txt'],
);

$builder->create_build_script();
