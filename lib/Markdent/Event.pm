package Markdent::Event;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( EventType Maybe Str HashRef );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has type => (
    is       => 'ro',
    isa      => EventType,
    required => 1,
);

has name => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has markup => (
    is      => 'ro',
    isa     => Maybe[Str],
    default => undef,
);

has attributes => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} },
);

has event_name => (
    is       => 'ro',
    isa      => Str,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_event_name',
);

sub _build_event_name {
    my $self = shift;

    my @parts = $self->type() eq 'inline' ? () : $self->type();
    push @parts, $self->name();

    return join q{_}, @parts;
}

__PACKAGE__->meta()->make_immutable();

1;
