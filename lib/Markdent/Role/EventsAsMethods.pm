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

__END__

=pod

=head1 NAME

Markdent::Role::DebugPrinter - Turns events into method calls

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

=head1 ROLES

This class does the L<Markdent::Role::Handler> role.

=head1 AUTHOR

Dave Rolsky, E<gt>autarch@urth.orgE<lt>

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
