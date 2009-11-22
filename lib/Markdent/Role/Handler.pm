package Markdent::Role::Handler;

use strict;
use warnings;

our $VERSION = '0.01';

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

__END__

=pod

=head1 NAME

Markdent::Role::Handler - A required role for all handlers

=head1 DESCRIPTION

This role implements behavior shared by all handlers.

=head1 REQUIRED METHODS

=over 4

=item * $handler->handle_event(...)

=back

=head1 METHODS

This role wraps the C<< $object->handle_event() >> method with a modifier. If
the method is passed a list of key/value pairs, it calls C<<
Markdent::Event->new() >> with those parameters and then calls the original
method.

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
