package Markdent::Role::BlockParser;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose::Role;

with 'Markdent::Role::AnyParser';

requires 'parse_document';

has _span_parser => (
    is       => 'ro',
    does     => 'Markdent::Role::SpanParser',
    init_arg => 'span_parser',
    required => 1,
);

no Moose::Role;

1;

__END__

=pod

=head1 NAME

Markdent::Role::BlockParser - A role for block parsers

=head1 DESCRIPTION

This role implements behavior shared by all block parsers

=head1 REQUIRED METHODS

=over 4

=item * $parse->parse_document(\$text)

This method takes a scalar reference to a markdown document and parses it for
block-level markup.

=back

=head1 ATTRIBUTES

This roles provides the following attributes:

=head2 _span_parser

This is a read-only attribute. It is an object which does the
L<Markdent::Role::SpanParser> role.

This is required for all block parsers.

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
