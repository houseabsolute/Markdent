package Markdent::Types::Internal;

use strict;
use warnings;

use IO::Handle;

use MooseX::Types -declare => [
    qw( HeaderLevel
        BlockParserClass
        SpanParserClass
        EventType
        OutputStream
        )
];

use MooseX::Types::Moose qw( Int ClassName Any FileHandle Object );

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

subtype OutputStream,
    as Any,
    where {
        FileHandle->check($_)
            || ( Object->check($_) && $_->can('print') );
    },
    message { 'The output stream must be a Perl file handle or an object with a print method' };

1;
