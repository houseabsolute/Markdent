package Test::Markdent;

use strict;
use warnings;

use Data::Dumper;
use HTML::Tidy;
use Test::Deep;
use Test::Differences;
use Test::More;
use Tree::Simple::Visitor::ToNestedArray;

use Markdent::Parser;
use Markdent::Handler::HTMLStream;
use Markdent::Handler::MinimalTree;

use Exporter qw( import );

our @EXPORT = qw( parse_ok html_output_ok );

sub parse_ok {
    my $markdown    = shift;
    my $expect_tree = shift;
    my $desc        = shift;

    my $handler = Markdent::Handler::MinimalTree->new();

    my $parser = Markdent::Parser->new( handler => $handler );

    $parser->parse( text => $markdown );

    my $visitor = Tree::Simple::Visitor::ToNestedArray->new();
    $handler->tree()->accept($visitor);

    # The top level of this data structure is always a one element array ref
    # containing the document contents.
    my $results = $visitor->getResults()->[0];

    diag( Dumper($results) )
        if $ENV{MARKDENT_TEST_VERBOSE};

    cmp_deeply( $results, $expect_tree, $desc );
}

sub html_output_ok {
    my $markdown    = shift;
    my $expect_html = shift;
    my $desc        = shift;

    my $capture = q{};
    open my $fh, '>', \$capture
        or die $!;

    my $handler = Markdent::Handler::HTMLStream->new(
        title  => 'Test',
        output => $fh,
    );

    my $parser = Markdent::Parser->new( handler => $handler );

    $parser->parse( text => $markdown );

    diag($capture)
        if $ENV{MARKDENT_TEST_VERBOSE};

    my $tidy = HTML::Tidy->new( { doctype => 'transitional' } );

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

    eq_or_diff( $tidy->clean($capture), $tidy->clean($real_expect_html), $desc );
}

1;
