package Markdent::Types::Internal;

use strict;
use warnings;

use MooseX::Types -declare => [
    qw( HeaderLevel
        BlockParserClass
        SpanParserClass
        EventType
        )
];

use MooseX::Types::Moose qw( Int ClassName );

subtype HeaderLevel,
    as Int,
    where { $_ >= 1 && $_ <= 6 },
    message { "Header level must be a number from 1-6 (not $_)" };

subtype BlockParserClass,
    as ClassName,
    where { $_->can('does') && $_->does('Markdent::Role::BlockParser') };

subtype SpanParserClass,
    as ClassName,
    where { $_->can('does') && $_->does('Markdent::Role::SpanParser') };

enum EventType, qw( start end inline );

1;
