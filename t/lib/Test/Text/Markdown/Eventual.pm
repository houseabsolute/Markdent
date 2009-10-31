package Test::Text::Markdown::Eventual;

use strict;
use warnings;

use Data::Dumper;
use Test::Deep;
use Test::More;
use Text::Markdown::Eventual;

use Exporter qw( import );

our @EXPORT = qw( parse_ok );

sub parse_ok {
    my $text        = shift;
    my $expect_tree = shift;
    my $desc        = shift;

    my $tree = Text::Markdown::Eventual::parse($text);

    warn( Dumper $tree )
        if $ENV{TME_VERBOSE};

    cmp_deeply( $tree, $expect_tree, $desc );
}



1;
