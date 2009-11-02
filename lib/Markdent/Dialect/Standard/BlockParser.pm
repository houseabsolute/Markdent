package Markdent::Dialect::Standard::BlockParser;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str ArrayRef );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::BlockParser';

has __buffered_lines => (
    traits   => ['Array'],
    is       => 'ro',
    isa      => ArrayRef [Str],
    default  => sub { [] },
    init_arg => undef,
    handles  => {
        _add_line_to_buffer => 'push',
        _buffered_lines     => 'elements',
        _has_buffer         => 'count',
        _last_buffered_line => [ 'get', -1 ],
        _clear_buffer       => 'clear',
    },
);

sub parse_line {
    my $self = shift;
    my $line = shift;

    $self->_match_atx_header($line) and return;

    $self->_match_paragraph_break($line) and return;

    $self->_match_two_line_header($line) and return;

    $self->_match_horizontal_rule($line) and return;

    $self->_add_line_to_buffer($line);
}

sub _match_atx_header {
    my $self = shift;
    my $line = shift;

    return unless $line =~ /^(\#{1,6})\s+(.+)/;

    my $level       = length $1;
    my $header_text = $2;

    $self->_debug_parse_result(
        $line,
        'atx header',
        [ level => $level ],
    ) if $self->debug();

    $self->_header( $level, $header_text );

    return 1;
}

sub _match_paragraph_break {
    my $self = shift;
    my $line = shift;

    return unless $line =~ /^\s*$/;

    return
        unless $self->_has_buffer()
            && $self->_last_buffered_line() =~ /\S/;

    $self->_paragraph( $self->_buffered_lines() );

    $self->_clear_buffer();

    return 1;
}

sub _match_two_line_header {
    my $self = shift;
    my $line = shift;

    return unless $line =~ /^(=+|-+)$/;

    my @buffer = $self->_buffered_lines();

    my $previous_line = pop @buffer;

    return unless defined $previous_line && $previous_line =~ /\S/;

    $self->_paragraph(@buffer)
        if @buffer;

    $self->_clear_buffer();

    my $level = substr( $line, 0, 1 ) eq '=' ? 1 : 2;

    $self->_debug_parse_result(
        [ $previous_line, $line ],
        'two-line header',
        [ level => $level ],
    ) if $self->debug();

    $self->_header( $level, $previous_line );

    return 1;
}

sub _match_horizontal_rule {
    my $self = shift;
    my $line = shift;

    return
        unless ( $line =~ /^[\s\*]+$/
                 && ( $line =~ tr/*/*/ ) >= 3 )
            || ( $line =~ /^[\s\-]+$/
                 && ( $line =~ tr/-/-/ ) >= 3 );

    return if $self->_has_buffer() && $self->_last_buffered_line() =~ /\S/;

    $self->_debug_parse_result(
        $line,
        'horizontal rule',
    ) if $self->debug();

    $self->_horizontal_rule();

    return 1;
}

sub _finalize_document {
    my $self = shift;

    return unless $self->_has_buffer;

    $self->_paragraph( $self->_buffered_lines() );

    $self->_clear_buffer();
}

sub _header {
    my $self  = shift;
    my $level = shift;
    my $text  = shift;

    $self->handler()->handle_event(
        type       => 'start',
        name       => 'header',
        attributes => { level => $level },
    );

    $self->span_parser()->parse_markup($text);

    $self->handler()->handle_event(
        type       => 'end',
        name       => 'header',
        attributes => { level => $level },
    );
}

sub _paragraph {
    my $self  = shift;
    my @lines = grep { /\S/ } @_;

    return unless @lines;

    $self->_debug_parse_result(
        \@lines,
        'paragraph',
    ) if $self->debug();

    $self->handler()->handle_event(
        type => 'start',
        name => 'paragraph',
    );

    my $text = join q{ }, @lines;
    $self->span_parser()->parse_markup($text);

    $self->handler()->handle_event(
        type => 'end',
        name => 'paragraph',
    );
}

sub _horizontal_rule {
    my $self = shift;

    $self->handler()->handle_event(
        type => 'inline',
        name => 'hr',
    );
}

__PACKAGE__->meta()->make_immutable();

1;
