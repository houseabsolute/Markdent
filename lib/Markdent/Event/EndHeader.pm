package Markdent::Event::EndHeader;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.38';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has level => (
    is       => 'ro',
    isa      => t('HeaderLevel'),
    required => 1,
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the end of a header

__END__

=pod

=head1 DESCRIPTION

This class represents the end of a header.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 level

A number from 1-6 indicating the header's level.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
