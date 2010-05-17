package Markdent::Dialect::Theory::SpanParser;

use strict;
use warnings;

our $VERSION = '0.10';

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

extends 'Markdent::Dialect::Standard::SpanParser';


override _build_escapable_chars => sub {
    my $chars = super();

    return [ @{ $chars }, qw( | : ) ];
};

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Span parser for Theory's Markdown

__END__

=pod

=head1 DESCRIPTION

This class extends the L<Markdent::Dialect::Standard::SpanParser> class in
order to allow the pipe (|) and colon (:) characters to be
backslash-escaped. These are used to mark tables, so they need to be
escapeable.

=head1 METHODS

This class provides the following methods:

=head1 ROLES

This class does the L<Markdent::Role::SpanParser>,
L<Markdent::Role::AnyParser>, and L<Markdent::Role::DebugPrinter> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
