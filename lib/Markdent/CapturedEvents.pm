package Markdent::CapturedEvents;

use strict;
use warnings;
use namespace::autoclean;

use Markdent::Types qw( ArrayRef EventObject );
use MooseX::Params::Validate qw( pos_validated_list );

use Moose;
use MooseX::StrictConstructor;

has _events => (
    is       => 'ro',
    isa      => ArrayRef [EventObject],
    init_arg => 'events',
    default  => sub { [] },
);

sub events {
    @{ $_[0]->_events() };
}

sub capture_events {
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
    my ($handler)
        = pos_validated_list( \@_, { does => 'Markdent::Role::Handler' } );

    $handler->handle_event($_) for $self->events();
}

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Represents a series of captured events

__END__

=pod

=head1 DESCRIPTION

This represents a series of captured parser events, and can be used to replay
them with a handle.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::CapturedEvents->new( events => \@events );

Creates a new Markdent::CapturedEvents object.

=head2 $captured->events()

Returns the captured events as an array.

=head2 $captured->capture_events(@events)

Captures one or more events.

=head2 $captured->replay_events($handler)

Given an object which does the L<Markdent::Role::Handler> role, this method
will replay all the captured events to that handler.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
