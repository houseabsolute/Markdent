package Markdent::Event::StartTable;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.31';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has caption => (
    is        => 'ro',
    isa       => t('Str'),
    predicate => 'has_caption',
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the start of a table

__END__

=pod

=head1 DESCRIPTION

This class represents the start of a table.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 caption

The caption for the table. This is optional.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
