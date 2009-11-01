package Test::Markdent;

use strict;
use warnings;

use Data::Dumper;
use Tree::Simple::Visitor::ToNestedArray;
use Test::Deep;
use Test::More;
use Markdent;
use Markdent::Handler::MinimalTree;

use Exporter qw( import );

our @EXPORT = qw( parse_ok );

sub parse_ok {
    my $text        = shift;
    my $expect_tree = shift;
    my $desc        = shift;

    my $handler = Markdent::Handler::MinimalTree->new();

    my $parser = Markdent->new( handler => $handler );

    $parser->parse( text => $text );

    my $visitor = Tree::Simple::Visitor::ToNestedArray->new();
    $handler->tree()->accept($visitor);

    # The top level of this data structure is always a one element array ref
    # containing the document contents.
    my $results = $visitor->getResults()->[0];
    warn Dumper($results)
        if $ENV{MARKDENT_VERBOSE};

    cmp_deeply( $results, $expect_tree, $desc );
}



1;
