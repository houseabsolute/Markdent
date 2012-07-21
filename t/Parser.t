use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use Markdent::Dialect::Theory::BlockParser;
use Markdent::Handler::MinimalTree;
use Markdent::Parser;

use lib 't/lib';

my $handler = Markdent::Handler::MinimalTree->new();

{
    my $parser = Markdent::Parser->new(
        dialects => 'Theory',
        handler  => $handler,
    );

    ok(
        $parser->_block_parser()->meta()
            ->does_role('Markdent::Dialect::Theory::BlockParser'),
        '$parser->_block_parser() with dialects = Theory'
    );

    ok(
        $parser->_span_parser()->meta()
            ->does_role('Markdent::Dialect::Theory::SpanParser'),
        '$parser->_span_parser() with dialects = Theory'
    );
}

{
    my $parser = Markdent::Parser->new(
        dialects => ['Theory'],
        handler  => $handler,
    );

    ok(
        $parser->_block_parser()->meta()
            ->does_role('Markdent::Dialect::Theory::BlockParser'),
        '$parser->_block_parser() with dialects = [Theory]'
    );

    ok(
        $parser->_span_parser()->meta()
            ->does_role('Markdent::Dialect::Theory::SpanParser'),
        '$parser->_span_parser() with dialects = [Theory]'
    );
}

{
    my $parser = Markdent::Parser->new(
        dialects => ['Example::Dialect'],
        handler  => $handler,
    );

    ok(
        $parser->_block_parser()->meta()
            ->does_role('Example::Dialect::BlockParser'),
        '$parser->_block_parser() with dialects = Theory'
    );

    ok(
        $parser->_span_parser()->meta()
            ->does_role('Example::Dialect::SpanParser'),
        '$parser->_span_parser() with dialects = Theory'
    );
}

{
    my $parser = Markdent::Parser->new(
        dialect => 'Theory',
        handler => $handler,
    );

    ok(
        $parser->_block_parser()->meta()
            ->does_role('Markdent::Dialect::Theory::BlockParser'),
        '$parser->_block_parser() with dialect = Theory (dialect as synonym for dialects)'
    );

    ok(
        $parser->_span_parser()->meta()
            ->does_role('Markdent::Dialect::Theory::SpanParser'),
        '$parser->_span_parser() with dialect = Theory (dialect as synonym for dialects)'
    );
}

done_testing();
