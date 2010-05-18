package Markdent::Event::StartListItem;

use strict;
use warnings;

our $VERSION = '0.10';

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the start of a list item

__END__

=pod

=head1 DESCRIPTION

This class represents the start of a list item.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
