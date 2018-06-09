package Markdent::Event::CodeBlock;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.32';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has code => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

has language => (
    is        => 'ro',
    isa       => t('Str'),
    predicate => 'has_language',
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for a code block

__END__

=pod

=head1 DESCRIPTION

This class represents a block of code

=head1 ATTRIBUTES

This class has the following attributes:

=head2 code

The code in the block, including newlines and additional leading space, etc.

=head2 language

An optional language associated with the block, if one was specified. You can
use the C<has_language()> method to see if one is set.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
