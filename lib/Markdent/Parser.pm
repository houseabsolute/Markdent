package Markdent::Parser;

use strict;
use warnings;

our $VERSION = '0.02';

use Markdent::Dialect::Standard::BlockParser;
use Markdent::Dialect::Standard::SpanParser;
use Markdent::Types qw( Str HashRef BlockParserClass SpanParserClass );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

with 'Markdent::Role::AnyParser';

has _block_parser_class => (
    is       => 'ro',
    isa      => BlockParserClass,
    init_arg => 'block_parser_class',
    default  => 'Markdent::Dialect::Standard::BlockParser',
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

has _span_parser_class => (
    is       => 'ro',
    does     => SpanParserClass,
    init_arg => 'span_parser_class',
    default  => 'Markdent::Dialect::Standard::SpanParser',
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
        $self->_span_parser_class()->meta()->get_all_attributes()
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
        $self->_block_parser_class()->meta()->get_all_attributes()
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

    return $self->_block_parser_class()->new( $self->_block_parser_args() );
}

sub _build_span_parser {
    my $self = shift;

    return $self->_span_parser_class()->new( $self->_span_parser_args() );
}

sub parse {
    my $self = shift;
    my ($text) = validated_list(
        \@_,
        markdown => { isa => Str },
    );

    $self->_clean_text(\$text);

    $self->_send_event('StartDocument');

    $self->_block_parser()->parse_document(\$text);

    $self->_send_event('EndDocument');

    return;
}

sub _clean_text {
    my $self = shift;
    my $text = shift;

    ${$text} =~ s/\r\n?/\n/g;
    ${$text} .= "\n"
        unless substr( ${$text}, -1, 1 ) eq "\n";

    return;
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Parser - A markdown parser

=head1 SYNOPSIS

  my $handler = Markdent::Handler::HTMLStream->new( ... );

  my $parser = Markdent::Parser->new(
      block_parser_class => '...',
      span_parser_class  => '...',
      handler            => $handler,
  );

  $parse->parse( markdown => $markdown );

=head1 DESCRIPTION

This class provides the primary interface for creating a parser. It ties a
block and span parser together with a handler.

By default, it will parse the standard Markdown dialect, but you can provide
alternate block or span parser classes.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Parser->new(...)

This method creates a new parser. It accepts the following parameters:

=over 4

=item * block_parser_class => $class

This default to L<Markdent::Dialect::Standard::BlockParser>, but can be any
class which implements the L<Markdent::Role::BlockParser> role.

=item * span_parser_class => $class

This default to L<Markdent::Dialect::Standard::SpanParser>, but can be any
class which implements the L<Markdent::Role::SpanParser> role.

=item * handler => $handler

This can be any object which implements the L<Markdent::Role::Handler>
role. It is required.

=back

=head2 $parser->parse( markdown => $markdown )

This method parses the given document. The parsing will cause events to be
fired which will be passed to the parser's handler.

=head1 ROLES

This class does the L<Markdent::Role::EventsAsMethods> and
L<Markdent::Role::Handler> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
