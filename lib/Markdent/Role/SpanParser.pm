package Markdent::Role::SpanParser;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.41';

use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_block';

1;

# ABSTRACT: A role for span parsers

__END__

=pod

=head1 DESCRIPTION

This role implements behavior shared by all span parsers.

=head1 REQUIRED METHODS

=over 4

=item * $parser->parse_block(\$text)

This method takes a scalar reference to a markdown block and parses it for
span-level markup.

=back

=head1 ROLES

This role does the L<Markdent::Role::AnyParser> and
L<Markdent::Role::DebugPrinter> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
