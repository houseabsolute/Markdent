package Markdent::Event::StartTableCell;

use strict;
use warnings;

our $VERSION = '0.02';

use Markdent::Types qw( TableCellAlignment PosInt Bool );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has alignment => (
    is       => 'ro',
    isa      => TableCellAlignment,
    required => 1,
);

has colspan => (
    is       => 'ro',
    isa      => PosInt,
    required => 1,
);

has is_header_cell => (
    is      => 'ro',
    isa     => Bool,
    default => 0,
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Event::StartTableCell - An event for the start of a table cell

=head1 DESCRIPTION

This class represents the start of a table cell.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 alignment

The alignment for the cell. This will be one of "left", "right", or "center".

=head2 colspan

The colspan for the cell. This will be a positive integer.

=head2 is_header_cell

A boolean indicating whether the cell is a header cell. This will be true for
all cells in the table's header, but can also be true for cells in the table's
body.

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
