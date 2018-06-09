package Markdent::Event::EndCode;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.32';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has delimiter => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

with(
    'Markdent::Role::Event'         => { event_class => __PACKAGE__ },
    'Markdent::Role::BalancedEvent' => { compare     => ['delimiter'] },
    'Markdent::Role::EventAsText'
);

sub as_text { $_[0]->delimiter() }

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the end of a code span

__END__

=pod

=head1 DESCRIPTION

This class represents the end of a code span.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 delimiter

The delimiter for the code span.

=head1 METHODS

This class has the following methods:

=head2 $event->as_text()

Returns the event's delimiter.

=head1 ROLES

This class does the L<Markdent::Role::Event> and
L<Markdent::Role::BalancedEvent> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
