use strict;
use warnings;

use Test::Exception;
use Test::More;

use Markdent::Dialect::Theory::BlockParser;
use Markdent::Handler::MinimalTree;
use Markdent::Parser;

use lib 't/lib';

my $handler = Markdent::Handler::MinimalTree->new();

{
    my $parser = Markdent::Parser->new(
        block_parser_class => 'Markdent::Dialect::Theory::BlockParser',
        handler            => $handler,
    );

    isa_ok(
        $parser->_block_parser(),
        'Markdent::Dialect::Theory::BlockParser',
        '$parser->_block_parser() with explicit class name'
    );
}

{
    my $parser = Markdent::Parser->new(
        dialect => 'Theory',
        handler => $handler,
    );

    isa_ok(
        $parser->_block_parser(),
        'Markdent::Dialect::Theory::BlockParser',
        '$parser->_block_parser() with dialect = Theory'
    );

    isa_ok(
        $parser->_span_parser(),
        'Markdent::Dialect::Standard::SpanParser',
        '$parser->_span_parser() with dialect = Theory'
    );
}

{
    throws_ok {
        my $parser = Markdent::Parser->new(
            dialect            => 'Theory',
            block_parser_class => 'Markdent::Dialect::Standard::BlockParser',
            handler            => $handler,
        );
    }
    qr/\QYou specified a dialect (Theory) which has its own block_parser class/,
        'Cannot specify a dialect and an overlapping explicit block parser class';
}

{
    my $parser = Markdent::Parser->new(
        dialect => 'Example::Dialect',
        handler => $handler,
    );

    isa_ok(
        $parser->_block_parser(),
        'Example::Dialect::BlockParser',
        '$parser->_block_parser() with dialect = Example::Dialect'
    );

    isa_ok(
        $parser->_span_parser(),
        'Example::Dialect::SpanParser',
        '$parser->_span_parser() with dialect = Example::Dialect'
    );
}

done_testing();
