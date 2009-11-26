package Markdent::Role::SpanParser;

use strict;
use warnings;

our $VERSION = '0.03';

use namespace::autoclean;
use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_block';

1;

__END__

=pod

=head1 NAME

Markdent::Role::SpanParser - A role for span parsers

=head1 DESCRIPTION

This role implements behavior shared by all span parsers

=head1 REQUIRED METHODS

=over 4

=item * $parser->parse_block(\$text)

This method takes a scalar reference to a markdown block and parses it for
span-level markup.

=back

=head1 ROLES

This class does the L<Markdent::Role::AnyParser> and
L<Markdent::Role::DebugPrinter> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
