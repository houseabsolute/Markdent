package Markdent::Event::Text;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.29';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has text => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

has _converted_from => (
    is        => 'ro',
    isa       => t('Str'),
    predicate => '_has_converted_from',
);

has _merged_from => (
    is        => 'ro',
    isa       => t( 'ArrayRef', of => t('Str') ),
    predicate => '_has_merged_from',
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for plain text

__END__

=pod

=head1 DESCRIPTION

This class represents plain text.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 text

The text.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
