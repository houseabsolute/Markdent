package Markdent::Event::Preformatted;

use strict;
use warnings;
use namespace::autoclean;

use Markdent::Types qw( Str );

use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event';

has text => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for preformatted text

__END__

=pod

=head1 DESCRIPTION

This class represents a block of preformatted text.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 text

The text in the block, including newlines and additional leading space, etc.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
