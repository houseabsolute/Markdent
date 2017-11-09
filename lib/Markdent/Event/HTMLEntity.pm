package Markdent::Event::HTMLEntity;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.27';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has entity => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for an HTML entity

__END__

=pod

=head1 DESCRIPTION

This class represents an HTML entity, like "amp" or "#0xc3".

=head1 ATTRIBUTES

This class has the following attributes:

=head2 entity

The text of the entity. This omits the leading ampersand and ending
semi-colon.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
