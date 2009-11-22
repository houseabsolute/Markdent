package Markdent::Event::EndHeader;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( HeaderLevel );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has level => (
    is       => 'ro',
    isa      => HeaderLevel,
    required => 1,
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__
