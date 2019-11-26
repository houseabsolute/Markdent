package Markdent::Role::Handler;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.37';

use Moose::Role;

requires 'handle_event';

1;

# ABSTRACT: A required role for all handlers

__END__

=pod

=head1 DESCRIPTION

This role implements an interface shared by all handlers.

=head1 REQUIRED METHODS

=over 4

=item * $handler->handle_event($event)

This method will always be called with a single object which does the
L<Markdent::Role::Event> role.

=back

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
