package Markdent::Event::StartHeader;

use strict;
use warnings;

our $VERSION = '0.06';

use Markdent::Types qw( HeaderLevel );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has level => (
    is       => 'ro',
    isa      => HeaderLevel,
    required => 1,
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Event::StartHeader - An event for the start of a header

=head1 DESCRIPTION

This class represents the start of a header.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 level

A number from 1-6 indicating the header's level.

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
