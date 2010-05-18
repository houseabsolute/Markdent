package Markdent::Event::EndOrderedList;

use strict;
use warnings;

our $VERSION = '0.10';

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the end of a ordered list

__END__

=pod

=head1 DESCRIPTION

This class represents the end of a ordered list.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
