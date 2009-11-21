package Markdent::Role::BlockParser;

use strict;
use warnings;

use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_document';

has _span_parser => (
    is       => 'ro',
    does     => 'Markdent::Role::SpanParser',
    init_arg => 'span_parser',
    required => 1,
);

no Moose::Role;

1;
