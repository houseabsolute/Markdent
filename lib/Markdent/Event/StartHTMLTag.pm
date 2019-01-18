package Markdent::Event::StartHTMLTag;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.34';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has tag => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

has attributes => (
    is      => 'ro',
    isa     => t('HashRef'),
    default => sub { {} },
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for the start of an inline HTML tag

__END__

=pod

=head1 DESCRIPTION

This class represents the start of an inline HTML tag.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 tag

The tag that is starting.

=head2 attributes

A hash reference of attributes as key/value pairs. An attribute without a
value will have a value of C<undef> in the hash reference.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
