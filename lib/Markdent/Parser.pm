package Markdent::Parser;

use strict;
use warnings;

our $VERSION = '0.10';

use Class::MOP;
use Markdent::Dialect::Standard::BlockParser;
use Markdent::Dialect::Standard::SpanParser;
use Markdent::Types qw( Str HashRef BlockParserClass SpanParserClass );
use MooseX::Params::Validate qw( validated_list );
use Try::Tiny;

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

with 'Markdent::Role::AnyParser';

has _block_parser_class => (
    is       => 'rw',
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
    is       => 'rw',
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

    $self->_set_classes_for_dialect($args);

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

sub _set_classes_for_dialect {
    my $self    = shift;
    my $args    = shift;

    my $dialect = delete $args->{dialect}
        or return;

    for my $pair (
        map { [ $_, $self->_class_name_for_dialect( $dialect, $_ ) ] }
        qw( block_parser span_parser ) ) {

        my ( $thing, $class ) = @{$pair};

        my $loaded;
        try {
            Class::MOP::load_class($class);
            $loaded = 1;
        }
        catch {

            # XXX - This is kind of broken, since a user can typo a dialect
            # and that will just get ignored.
            die $_ unless $_ =~ /Can't locate/;
        };

        next unless $loaded;

        if ( exists $args->{ $thing . '_class' } ) {
            die
                "You specified a dialect ($dialect) which has its own $thing class"
                . " and you also specified an explicit $thing class."
                . " You cannot specify both when creating a Markdent::Parser.";
        }

        my $meth = '_set_' . $thing . '_class';
        $self->$meth($class);
    }
}

sub _class_name_for_dialect {
    my $self    = shift;
    my $dialect = shift;
    my $type    = shift;

    my $suffix = join q{}, map {ucfirst} split /_/, $type;

    if ( $dialect =~ /::/ ) {
        return join '::', $dialect, $suffix;
    }
    else {
        return join '::', 'Markdent::Dialect', $dialect, $suffix;
    }
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

# ABSTRACT: A markdown parser

__END__

=pod

=head1 SYNOPSIS

  my $handler = Markdent::Handler::HTMLStream->new( ... );

  my $parser = Markdent::Parser->new(
      dialect => ...,
      handler => $handler,
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

=item * dialect => $name

You can use this as a shorthand to pick a block and/or span parser class.

If the dialect parameter does not contain a namespace separator (::), the
constructor looks for classes named
C<Markdent::Dialect::${dialect}::BlockParser> and
C<Markdent::Dialect::${dialect}::SpanParser>.

If the dialect parameter does contain a namespace separator, it is used a
prefix - C<$dialect::BlockParser> and C<$dialect::SpanParser>.

If any relevant classes are found, they will be used by the parser.

You can I<also> specify an explicit block or span parser, but if the dialect
has its own class of that type, an error will be thrown.

If the dialect only specifies a block or span parser, but not both, then we
fall back to using the appropriate parser for the Standard dialect.

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

=cut
