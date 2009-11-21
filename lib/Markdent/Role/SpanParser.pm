package Markdent::Role::SpanParser;

use strict;
use warnings;

use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_block';

no Moose::Role;

1;
