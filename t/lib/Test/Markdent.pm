package Test::Markdent;

use strict;
use warnings;

use Data::Dumper;
use Test::Deep;
use Test::Differences;
use Test::More;
use Tree::Simple::Visitor::ToNestedArray;

eval { require HTML::Tidy };
my $HasTidy = $@ ? 0 : 1;

use Markdent::Handler::MinimalTree;
use Markdent::Parser;
use Markdent::Simple;

use Exporter qw( import );

our @EXPORT = qw( tree_from_handler parse_ok html_output_ok );

sub parse_ok {
    my $parser_p    = ref $_[0] ? shift : {};
    my $markdown    = shift;
    my $expect_tree = shift;
    my $desc        = shift;

    my $handler = Markdent::Handler::MinimalTree->new();

    my $parser = Markdent::Parser->new( %{$parser_p}, handler => $handler );

    $parser->parse( markdown => $markdown );

    my $results = tree_from_handler($handler);

    diag( Dumper($results) )
        if $ENV{MARKDENT_TEST_VERBOSE};

    cmp_deeply( $results, $expect_tree, $desc );
}

sub tree_from_handler {
    my $handler = shift;

    my $visitor = Tree::Simple::Visitor::ToNestedArray->new();
    $handler->tree()->accept($visitor);

    # The top level of this data structure is always a one element array ref
    # containing the document contents.
    return $visitor->getResults()->[0];
}

sub html_output_ok {
    my $dialect     = ref $_[0] ? shift : {};
    my $markdown    = shift;
    my $expect_html = shift;
    my $desc        = shift;

    unless ($HasTidy) {
    SKIP: { skip 'This test requires HTML::Tidy', 1; }

        return;
    }

    my $html = Markdent::Simple->new()->markdown_to_html(
        %{$dialect},
        title    => 'Test',
        markdown => $markdown,
    );

    diag($html)
        if $ENV{MARKDENT_TEST_VERBOSE};

    my $tidy = HTML::Tidy->new(
        {
            doctype           => 'transitional',
            'sort-attributes' => 'alpha',
        }
    );

    my $real_expect_html = <<"EOF";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
  <title>Test</title>
</head>
<body>
$expect_html
</body>
</html>
EOF

    eq_or_diff( $tidy->clean($html), $tidy->clean($real_expect_html), $desc );
}

1;
