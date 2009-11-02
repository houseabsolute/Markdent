package Markdent::Role::BlockParser;

use strict;
use warnings;

use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_line';

has span_parser => (
    is       => 'ro',
    does     => 'Markdent::Role::SpanParser',
    required => 1,
);

no Moose::Role;

1;
