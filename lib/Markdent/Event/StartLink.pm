package Markdent::Event::StartLink;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str Bool );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has uri => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has title => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_title',
);

has id => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_id',
);

has is_implicit_id => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__
