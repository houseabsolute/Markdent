package Markdent::Role::AnyParser;

use strict;
use warnings;

our $VERSION = '0.01';

use Moose::Role;

with 'Markdent::Role::DebugPrinter';

has handler => (
    is       => 'ro',
    does     => 'Markdent::Role::Handler',
    required => 1,
);

sub _send_event {
    my $self = shift;

    $self->handler()->handle_event( $self->_make_event(@_) );
}

sub _make_event {
    my $self  = shift;
    my $class = shift;

    my $real_class = $class =~ /::/ ? $class : 'Markdent::Event::' . $class;

    return $real_class->new(@_);
}

sub _detab_text {
    my $self = shift;
    my $text = shift;

    # Ripped off from Text::Mardkown
    ${$text} =~ s{ ^
                   (.*?)
                   \t
                 }
                 { $1 . (q{ } x (4 - length($1) % 4))}xmge;

    return;
}

no Moose::Role;

1;

__END__

=pod

=head1 NAME

Markdent::Role::AnyParser - A role for block and span parsers

=head1 DESCRIPTION

This role implements behavior shared by all types of parser.

=head1 ATTRIBUTES

This roles provides the following attributes:

=head2 handler

This is a read-only attribute. It is an object which does the
L<Markdent::Role::Handler> role.

This is required for all parsers.

=head1 METHODS

=head2 $parser->_detab_text(\$text)

This takes a scalar reference to a piece of text that will be outputted and
replaces tabs with spaces.

=head1 ROLES

This class does the L<Markdent::Role::DebugPrinter> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
