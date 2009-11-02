package Markdent::Role::SpanParser;

use strict;
use warnings;

use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_markup';

no Moose::Role;

1;
