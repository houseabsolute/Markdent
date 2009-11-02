package Markdent::Dialect::Standard::SpanParser;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str ArrayRef );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::SpanParser';

has __current_spans => (
    traits   => ['Array'],
    is       => 'ro',
    isa      => ArrayRef[Str],
    default  => sub { [] },
    init_arg => undef,
    handles  => {
        _current_spans       => 'elements',
        _add_current_span    => 'push',
        _remove_current_span => 'shift',
    },
);

has _span_text_buffer => (
    traits   => ['String'],
    is       => 'ro',
    isa      => Str,
    default  => q{},
    init_arg => undef,
    handles  => {
        _save_span_text         => 'append',
        _has_span_text_buffer   => 'length',
        _clear_span_text_buffer => 'clear',
    },
);

sub parse_markup {
    my $self = shift;
    my $text = shift;

    $self->_print_debug( "Parsing text for span-level markup\n\n$text\n" )
        if $self->debug();

    # Note that we have to pass a _reference_ to text in order to make sure
    # that we are matching the same variable with /g regexes each time.
 PARSE_MARKUP:
    while (1) {
        if ( $text =~ /\G\z/gc ) {
            $self->_event_for_text_buffer();
            last;
        }

        for my $span ( $self->_possible_span_matches() ) {
            my $meth = '_match_' . $span;

            if ( $self->$meth( \$text ) ) {
                next PARSE_MARKUP;
            }
        }

        $self->_match_plain_text( \$text );
    }
}

sub _possible_span_matches {
    my $self = shift;

    my @look_for;

    for my $type ( qw( strong emphasis  ) ) {
        if ( $self->_current_span_includes($type) ) {
            push @look_for, $type . '_end';
        }
        else {
            push @look_for, $type . '_start';
        }
    }

    return @look_for;
    push @look_for, qw( link image );

    return @look_for;
}

sub _current_span_includes {
    my $self = shift;
    my $span = shift;

    return grep { $_ eq $span } $self->_current_spans();
}

sub _match_strong_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/(?:\*\*|__)/ )
        or return;

    $self->_markup_event('start_strong');

    $self->_add_current_span('strong');

    return 1;
}

sub _match_strong_end {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_end( $text, qr/(?:\*\*|__)/ )
        or return;

    $self->_markup_event('end_strong');

    $self->_remove_current_span();

    return 1;
}

sub _match_emphasis_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/(?:\*|_)/ )
        or return;

    $self->_markup_event('start_emphasis');

    $self->_add_current_span('emphasis');

    return 1;
}

sub _match_emphasis_end {
    my $self = shift;
    my $text = shift;

    $self->_match_delimiter_end( $text, qr/(?:\*|_)/ )
        or return;

    $self->_markup_event('end_emphasis');

    $self->_remove_current_span();

    return 1;
}

sub _match_delimiter_start {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    return unless ${$text} =~ /(?: ^ | [ ] \G ) ($delim) (?= \S ) /xgc;

    return $1;
}

sub _match_delimiter_end {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    return unless ${$text} =~ /[^\s\\] \G $delim (?= \s | \z ) /xgc;

    return 1;
}

sub _match_plain_text {
    my $self = shift;
    my $text = shift;

    # Note that we're careful not to consume any of the characters marking the
    # (possible) end of the plain text. If those things turn out to _not_ be
    # markup, we'll get them on the next pass, because we always match at
    # least one character, so we should never get stuck in a loop.
    return unless
        ${$text} =~ /\G
                     ( .+? )              # at least one character followed by ...
                     (?:
                       (?= \* | _ | \` )  #   possible span markup
                       |
                       (?= !?\[ )         #   or a possible image or link
                       |
                       \z                 #   or the end of the string
                     )
                    /xgc;

    $self->_print_debug( "Interpreting as plain text\n\n[$1]\n" );

    my $plain = $self->_unescape_plain_text($1);

    $self->_save_span_text($plain);

    return 1;
}

sub _unescape_plain_text {
    my $self  = shift;
    my $plain = shift;

    $plain =~ s/\\([\`*_{}[\]()#+-.!])/$1/g;

    return $plain;
}

sub _markup_event {
    my $self = shift;
    my $meth = shift;

    $self->_event_for_text_buffer();

    $self->_print_debug( "Found markup: $meth\n" );

    $self->handler()->$meth(@_);
}

sub _event_for_text_buffer {
    my $self = shift;

    return unless $self->_has_span_text_buffer();

    $self->handler()->text( text => $self->_span_text_buffer() );
    $self->_clear_span_text_buffer();
}

use re 'eval';

# These two regexes stolen from Text::Markdown
my $nested_brackets;
$nested_brackets = qr{
    (?>                                 # Atomic matching
       [^\[\]]+                         # Anything other than brackets
     |
       \[
         (??{ $nested_brackets })       # Recursive set of nested brackets
       \]
    )*
}x;

my $nested_parens;
$nested_parens = qr{
    (?>                                 # Atomic matching
       [^()\s]+                         # Anything other than parens or whitespace
     |
       \(
         (??{ $nested_parens })         # Recursive set of nested brackets
       \)
    )*
}x;


__PACKAGE__->meta()->make_immutable();

1;
