package Markdent::Role::AnyParser;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.26';

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

sub _debug_look_for {
    my $self = shift;

    return unless $self->debug();

    my @look_debug = map { ref $_ ? "$_->[0] ($_->[1])" : $_ } @_;

    my $msg = "Looking for the following possible matches:\n";
    $msg .= "  - $_\n" for @look_debug;

    $self->_print_debug($msg);
}

1;

# ABSTRACT: A role for block and span parsers

__END__

=pod

=head1 DESCRIPTION

This role implements behavior shared by all types of parser.

=head1 ATTRIBUTES

This role provides the following attributes:

=head2 handler

This is a read-only attribute. It is an object which does the
L<Markdent::Role::Handler> role.

This is required for all parsers.

=head1 METHODS

=head2 $parser->_detab_text(\$text)

This takes a scalar reference to a piece of text that will be outputted and
replaces tabs with spaces. This is down I<after> a piece of text is parser for
markup.

=head1 ROLES

This class does the L<Markdent::Role::DebugPrinter> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
