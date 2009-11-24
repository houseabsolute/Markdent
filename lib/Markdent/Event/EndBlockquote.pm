package Markdent::Event::EndBlockquote;

use strict;
use warnings;

our $VERSION = '0.01';

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Event::EndBlockquote - An event for the end of a blockquote

=head1 DESCRIPTION

This class represents the end of a blockquote.

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
