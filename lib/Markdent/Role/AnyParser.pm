package Markdent::Role::AnyParser;

use strict;
use warnings;

use Moose::Role;

with 'Markdent::Role::DebugPrinter';

has handler => (
    is       => 'ro',
    does     => 'Markdent::Role::Handler',
    required => 1,
);

no Moose::Role;

1;
