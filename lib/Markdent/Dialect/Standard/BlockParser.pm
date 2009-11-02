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

        # empty line
    }
    elsif ( $line =~ /^(=+|-+)$/ ) {
        my @buffer = $self->_buffered_lines();

        my $header_text = pop @buffer;

        if (@buffer) {
            $self->_paragraph(@buffer);
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

sub _header {
    my $self  = shift;
    my $level = shift;
    my $text  = shift;

    $self->handler()->start_header( level => $level );
    $self->span_parser()->parse_markup($text);
    $self->handler()->end_header();
}

__PACKAGE__->meta()->make_immutable();

1;
