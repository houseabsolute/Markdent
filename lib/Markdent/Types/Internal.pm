package Markdent::Types::Internal;

use strict;
use warnings;

use MooseX::Types -declare => [
    qw( HeaderLevel
        BlockParserClass
        SpanParserClass
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
    where { warn "$_\n";$_->can('does') && $_->does('Markdent::Role::SpanParser') };

1;
