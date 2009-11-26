package Markdent::Event::HTMLComment;

use strict;
use warnings;

our $VERSION = '0.03';

use Markdent::Types qw( Str HashRef );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has text => (
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

Markdent::Event::HTMLComment - An event for an HTML comment

=head1 DESCRIPTION

This class represents the an HTML comment.

=head1 ATTRIBUTES

This class has the following attributes:

=head2 text

The text of the comment.

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
