package Markdent::Event::HTMLComment;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.31';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has text => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for an HTML comment

__END__

=pod

=head1 DESCRIPTION

This class represents the an HTML comment.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 text

The text of the comment.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
