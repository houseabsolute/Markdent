package Markdent::Role::Handler;

use strict;
use warnings;

use Markdent::Event;

use namespace::autoclean;
use Moose::Role;

requires 'handle_event';

around handle_event => sub {
    my $orig = shift;
    my $self = shift;

    my $event = @_ > 1 ? Markdent::Event->new(@_) : shift;

    return $self->$orig($event);
};

1;
