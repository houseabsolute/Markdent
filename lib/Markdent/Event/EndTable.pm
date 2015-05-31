package Markdent::Event::EndTable;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.27';

use Markdent::Types qw( Str );

use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the end of a table

__END__

=pod

=head1 DESCRIPTION

This class represents the end of a table.

=head1 ATTRIBUTES

This class has the following attributes:

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
