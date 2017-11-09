package Markdent::Event::Image;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.27';

use Markdent::Types;

use Moose;
use MooseX::StrictConstructor;

has uri => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

has alt_text => (
    is       => 'ro',
    isa      => t('Str'),
    required => 1,
);

has title => (
    is        => 'ro',
    isa       => t('Str'),
    predicate => 'has_title',
);

has id => (
    is        => 'ro',
    isa       => t('Str'),
    predicate => 'has_id',
);

has is_implicit_id => (
    is      => 'ro',
    isa     => t('Bool'),
    default => 0,
);

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for an image

__END__

=pod

=head1 DESCRIPTION

This class represents an image.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 uri

The uri for the image.

=head2 alt_text

The alt text for the image.

=head2 title

The image title. This is optional.

=head2 id

The image's id. This is optional.

=head2 is_implicit_id

This will be true if the image's id was not specified explicitly in the
Markdown text.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
