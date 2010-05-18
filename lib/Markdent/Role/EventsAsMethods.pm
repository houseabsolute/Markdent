package Markdent::Role::EventsAsMethods;

use strict;
use warnings;

use Scalar::Util qw( blessed );

use namespace::autoclean;
use Moose::Role;

with 'Markdent::Role::Handler';

sub handle_event {
    my $self  = shift;
    my $event = shift;

    my $meth = $event->event_name();

    $self->$meth( $event->kv_pairs_for_attributes() );
}

1;

# ABSTRACT: Turns events into method calls

__END__

=pod

=head1 DESCRIPTION

This role takes a L<Markdent::Event> object and turns it into a method call.

=head1 METHODS

This role provides the following methods:

=head2 $object->handle_event($event)

This takes a L<Markdent::Event> object and turns it into a method call on the
object.

The method name is the same as the value of C<< $event->event_name() >>. The
hash reference returned by C<< $event->attributes() >> is turned into a set of
named parameters for the method. However, any keys starting with "!" in the
attributes will not be passed to the method.

So, for example, a L<Markdown::Event::StartLink> event turns into a method
call like this:

  $handler->start_link(
      uri            => $event->uri(),
      title          => $title,                     # optional
      id             => $id,                        # optional
      is_implicit_id => $event->is_implicit_id(),
  );

=head1 ROLES

This role does the L<Markdent::Role::Handler> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
