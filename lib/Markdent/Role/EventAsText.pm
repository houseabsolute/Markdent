package Markdent::Role::EventAsText;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.28';

use Moose::Role;

requires 'as_text';

1;

# ABSTRACT: Indicates that an event has an as_text method

__END__

=pod

=head1 DESCRIPTION

An event with an as_text method will do this role.

=head1 REQUIRED METHODS

=over 4

=item * $handler->as_text()

=back

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
