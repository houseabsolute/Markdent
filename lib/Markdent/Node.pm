package Markdent::Node;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( NodeType );

use namespace::autoclean;
use Moose;

has type => (
    is       => 'ro',
    isa      => NodeType,
    required => 1,
);

__PACKAGE__->meta()->make_immutable();
