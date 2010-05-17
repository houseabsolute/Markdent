package Markdent::Event::StartTable;

use strict;
use warnings;

our $VERSION = '0.10';

use Markdent::Types qw( Str );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has caption => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_caption',
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Event::StartTable - An event for the start of a table

=head1 DESCRIPTION

This class represents the start of a table.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 caption

The caption for the table. This is optional.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
