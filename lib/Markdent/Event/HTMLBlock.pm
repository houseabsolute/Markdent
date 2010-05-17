package Markdent::Event::HTMLBlock;

use strict;
use warnings;

our $VERSION = '0.10';

use Markdent::Types qw( Str );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has html => (
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

Markdent::Event::HTMLBlock - An event for an HTML block

=head1 DESCRIPTION

This class represents a standalone block of HTML.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 html

The HTML in the block. There is no guarantee that this HTML is actually valid.

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
