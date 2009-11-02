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
    isa      => ArrayRef[Str],
    default  => sub { [] },
    init_arg => undef,
    handles  => {
        _push_buffer    => 'push',
        _buffered_lines => 'elements',
        _has_buffer     => 'count',
        _clear_buffer   => 'clear',
    },
);

sub parse_line {
    my $self = shift;
    my $line = shift;

    if ( $line =~ /^(\#{1,6})\s+(.+)/ ) {
        my $level       = length $1;
        my $header_text = $2;

        $self->_debug_parse_result(
            $line,
            'atx header',
            [ level => $level ],
        ) if $self->debug();

        $self->_header( $level, $header_text );
    }
    elsif ( $line =~ /^\s*$/ ) {
        $self->_paragraph( $self->_buffered_lines() )
            if $self->_has_buffer;

        $self->_clear_buffer();
    }
    elsif ( $line =~ /^(=+|-+)$/ ) {
        my @buffer = $self->_buffered_lines();

        my $header_text = pop @buffer;

        if (@buffer) {
            $self->_paragraph(\@buffer);
        }

        my $level = substr( $1, 0, 1 ) eq '=' ? 1 : 2;

        $self->_debug_parse_result(
            [ $header_text, $line ],
            'two-line header',
            [ level => $level ],
        ) if $self->debug();

        $self->_header( $level, $header_text );

        $self->_clear_buffer();
    }
    else {
        $self->_push_buffer($line);
    }
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
    my @lines = @_;

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

__PACKAGE__->meta()->make_immutable();

1;
