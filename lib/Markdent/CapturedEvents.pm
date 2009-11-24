package Markdent::CapturedEvents;

use strict;
use warnings;

our $VERSION = '0.02';

use Markdent::Types qw( ArrayRef EventObject );
use MooseX::Params::Validate qw( pos_validated_list );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has _events => (
    is       => 'ro',
    isa      => ArrayRef[EventObject],
    init_arg => 'events',
    default  => sub { [] },
);

sub events {
    @{ $_[0]->_events() };
}

sub add_events {
    my $self   = shift;
    my @events = pos_validated_list(
        \@_,
        ( { does => 'Markdent::Role::Event' } ) x ( @_ ? @_ : 1 ),
        MX_PARAMS_VALIDATE_NO_CACHE => 1,
    );

    push @{ $self->_events() }, @_;
}

sub replay_events {
    my $self = shift;
    my ($handler) = pos_validated_list( \@_, { does => 'Markdent::Role::Handler' } );

    $handler->handle_event($_) for $self->events();
}

__PACKAGE__->meta()->make_immutable();

1;

__END__
