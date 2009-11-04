package Markdent::Parser;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Dialect::Standard::BlockParser;
use Markdent::Dialect::Standard::SpanParser;
use Markdent::Types qw( Str HashRef BlockParserClass SpanParserClass );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

with 'Markdent::Role::AnyParser';

has block_parser_class => (
    is      => 'ro',
    isa     => BlockParserClass,
    default => 'Markdent::Dialect::Standard::BlockParser',
);

has _block_parser => (
    is       => 'ro',
    does     => 'Markdent::Role::BlockParser',
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_block_parser',
);

has _block_parser_args => (
    is       => 'rw',
    does     => HashRef,
    init_arg => undef,
);

has span_parser_class => (
    is      => 'ro',
    does    => SpanParserClass,
    default => 'Markdent::Dialect::Standard::SpanParser',
);

has _span_parser_args => (
    is       => 'rw',
    does     => HashRef,
    init_arg => undef,
);

has _span_parser => (
    is       => 'ro',
    does     => 'Markdent::Role::SpanParser',
    lazy     => 1,
    init_arg => undef,
    builder  => '_build_span_parser',
);

sub BUILD {
    my $self = shift;
    my $args = shift;

    my %sp_args;
    for my $key (
        grep {defined}
        map  { $_->init_arg() }
        $self->span_parser_class()->meta()->get_all_attributes()
        ) {

        $sp_args{$key} = $args->{$key}
            if exists $args->{$key};
    }

    $sp_args{handler} = $self->handler();

    $self->_set_span_parser_args(\%sp_args);

    my %bp_args;
    for my $key (
        grep {defined}
        map  { $_->init_arg() }
        $self->block_parser_class()->meta()->get_all_attributes()
        ) {

        $bp_args{$key} = $args->{$key}
            if exists $args->{$key};
    }

    $bp_args{handler} = $self->handler();
    $bp_args{span_parser} = $self->_span_parser();

    $self->_set_block_parser_args(\%bp_args);
}

sub _build_block_parser {
    my $self = shift;

    return $self->block_parser_class()->new( $self->_block_parser_args() );
}

sub _build_span_parser {
    my $self = shift;

    return $self->span_parser_class()->new( $self->_span_parser_args() );
}

sub parse {
    my $self = shift;
    my ($text) = validated_list(
        \@_,
        text => { isa => Str },
    );

    $self->_clean_text(\$text);

    $self->handler()->handle_event(
        type => 'start',
        name => 'document',
    );

    $self->_block_parser()->parse_document(\$text);

    $self->handler()->handle_event(
        type => 'end',
        name => 'document',
    );

    return;
}

sub _clean_text {
    my $self = shift;
    my $text = shift;

    ${$text} =~ s/\r\n?/\n/g;
    ${$text} .= "\n"
        unless substr( ${$text}, -1, 1 ) eq "\n";

    # XXX - not sure if this is really okay, but it does make parsing simpler
    # ;)
    ${$text} =~ s/\t/    /g;

    return;
}

__PACKAGE__->meta()->make_immutable();

1;
