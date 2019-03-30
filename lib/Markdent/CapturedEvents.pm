package Markdent::CapturedEvents;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.35';

use Markdent::Types;
use Params::ValidationCompiler qw( validation_for );
use Specio::Declare;

use Moose;
use MooseX::StrictConstructor;

has _events => (
    is       => 'ro',
    isa      => t( 'ArrayRef', of => t('EventObject') ),
    init_arg => 'events',
    default  => sub { [] },
);

sub events {
    @{ $_[0]->_events() };
}

{
    my $validator = validation_for(
        params => [ { type => t('EventObject') } ],
        slurpy => t('EventObject'),
    );

    sub capture_events {
        my $self   = shift;
        my @events = $validator->(@_);

        push @{ $self->_events() }, @events;
    }
}

{
    my $validator = validation_for(
        params => [ { type => t('HandlerObject') } ],
    );

    sub replay_events {
        my $self = shift;
        my ($handler) = $validator->(@_);

        $handler->handle_event($_) for $self->events();
    }
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
