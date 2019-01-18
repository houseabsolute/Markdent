package Markdent::Dialect::Theory::SpanParser;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.34';

use Moose::Role;

with 'Markdent::Role::Dialect::SpanParser';

around _build_escapable_chars => sub {
    my $orig  = shift;
    my $self  = shift;
    my $chars = $self->$orig();

    return [ @{$chars}, qw( | : ) ];
};

1;

# ABSTRACT: Span parser for Theory's proposed Markdown extensions

__END__

=pod

=head1 DESCRIPTION

This role is applied to a L<Markdent::Parser::SpanParser> in order to allow
the pipe (|) and colon (:) characters to be backslash-escaped. These are used
to mark tables, so they need to be escapeable.

=head1 ROLES

This role does the L<Markdent::Role::Dialect::SpanParser> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
