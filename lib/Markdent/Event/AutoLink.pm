package Markdent::Event::AutoLink;

use strict;
use warnings;

our $VERSION = '0.05';

use Markdent::Types qw( Str Bool );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has uri => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Event::AutoLink - An event for auto-links

=head1 DESCRIPTION

This class represents an auto-link, like C<< <http://example.com> >>.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 uri

The uri in the auto-link.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
