package Markdent::Role::EventAsText;

use strict;
use warnings;

our $VERSION = '0.07';

use namespace::autoclean;
use Moose::Role;

requires 'as_text';

1;

__END__

=pod

=head1 NAME

Markdent::Role::EventAsText - Indicates that an event has an as_text method

=head1 DESCRIPTION

An event with an as_text method will do this role.

=head1 REQUIRED METHODS

=over 4

=item * $handler->as_text()

=back

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
