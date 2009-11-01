package Markdent::Types::Internal;

use strict;
use warnings;

use MooseX::Types -declare => [ qw( HeaderLevel ) ];
use MooseX::Types::Moose qw( Int );

subtype HeaderLevel,
    as Int,
    where { $_ >= 1 && $_ <= 6 },
    message { "Header level must be a number from 1-6 (not $_)" };

1;
