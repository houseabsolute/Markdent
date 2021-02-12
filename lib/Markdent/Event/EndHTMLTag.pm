package Markdent::Event::EndHTMLTag;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.40';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has tag => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta->make_immutable;

1;

# ABSTRACT: An event for the end of an inline HTML tag

__END__

=head1 DESCRIPTION

This class represents the end of an inline HTML tag

=head1 ATTRIBUTES

This class has the following attributes:

=head2 tag

The tag that is ending.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
