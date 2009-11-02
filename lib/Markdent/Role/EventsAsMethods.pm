package Markdent::Role::EventsAsMethods;

use namespace::autoclean;
use Moose::Role;

with 'Markdent::Role::Handler';

sub handle_event {
    my $self  = shift;
    my $event = shift;

    my $meth = $event->event_name();

    my %p = %{ $event->attributes() };
    delete @p{ grep {/^!/} keys %p };

    $self->$meth(%p);
}

1;
