package Markdent::Event::Text;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str ArrayRef );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has text => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has _converted_from => (
    is        => 'ro',
    isa       => Str,
    predicate => '_has_converted_from',
);

has _merged_from => (
    is        => 'ro',
    isa       => ArrayRef[Str],
    predicate => '_has_merged_from',
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__
