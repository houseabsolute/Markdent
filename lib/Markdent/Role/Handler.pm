package Markdent::Role::Handler;

use strict;
use warnings;

our $VERSION = '0.09';

use namespace::autoclean;
use Moose::Role;

requires 'handle_event';

1;

__END__

=pod

=head1 NAME

Markdent::Role::Handler - A required role for all handlers

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

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
