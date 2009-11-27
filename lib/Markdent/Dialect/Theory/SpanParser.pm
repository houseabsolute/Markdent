package Markdent::Dialect::Theory::SpanParser;

use strict;
use warnings;

our $VERSION = '0.05';

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

__END__

=pod

=head1 NAME

Markdent::Dialect::Standard::SpanParser - Span parser for Theory's Markdown

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

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
