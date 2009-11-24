package Markdent::Event::EndHTMLTag;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has tag => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__

=head1 NAME

Markdent::Event::EndHTMLTag - An event for the end of an inline HTML tag

=head1 DESCRIPTION

This class represents the end of an inline HTML tag

=head1 ATTRIBUTES

This class has the following attributes:

=head2 tag

The tag that is ending.

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 AUTHOR

Dave Rolsky, E<gt>autarch@urth.orgE<lt>

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
