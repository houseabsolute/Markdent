package Markdent::Dialect::Standard::SpanParser;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str ArrayRef );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

with 'Markdent::Role::SpanParser';

has __pending_events => (
    traits   => ['Array'],
    is       => 'rw',
    isa      => ArrayRef['Markdent::Event'],
    default  => sub { [] },
    init_arg => undef,
    handles  => {
        _pending_events       => 'elements',
        _add_pending_event    => 'push',
        _clear_pending_events => 'clear',
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
    $self->_parse_text(\$text);

    # This catches any bad start events that were found after the last end
    # event, or if there were _no_ end events at all.
    $self->_convert_invalid_start_events_to_text('is done');

    $self->_debug_pending_events('before text merging');

    $self->_merge_consecutive_text_events();

    $self->_debug_pending_events('after text merging');

    $self->handler()->handle_event($_)
        for $self->_pending_events();

    $self->_clear_pending_events();

    return;
}

sub _parse_text {
    my $self = shift;
    my $text = shift;

 PARSE_MARKUP:
    while (1) {
        if ( ${$text} =~ /\G\z/gc ) {
            $self->_event_for_text_buffer();
            last;
        }

        for my $span ( $self->_possible_span_matches() ) {
            my ( $markup, @args ) = ref $span ? @{$span} : $span;

            my $meth = '_match_' . $markup;

            if ( $self->$meth( $text, @args ) ) {
                next PARSE_MARKUP;
            }
        }

        $self->_match_plain_text($text);
    }
}

sub _possible_span_matches {
    my $self = shift;

    my @look_for;

    for my $type (qw( strong emphasis code )) {
        if ( my $event = $self->_start_event_for_span($type) ) {
            push @look_for,
                [ $type . '_end', $event->attributes()->{delimiter} ];
        }
        else {
            push @look_for, $type . '_start';
        }
    }

    push @look_for, 'html';

    unless ( $self->_start_event_for_span('link') ) {
        push @look_for, qw( link image );
    }

    return @look_for;
}

sub _start_event_for_span {
    my $self = shift;
    my $type = shift;

    my $in;
    for my $event ( $self->_pending_events() ) {
        $in = $event
            if $event->event_name eq 'start_' . $type;

        undef $in
            if $event->event_name eq 'end_' . $type;
    }

    return $in;
}

sub _match_strong_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/(?:\*\*|__)/ )
        or return;

    my $event = Markdent::Event->new(
        type       => 'start',
        name       => 'strong',
        attributes => { delimiter => $delim },
    );

    $self->_markup_event($event);

    return 1;
}

sub _match_strong_end {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    $self->_match_delimiter_end( $text, qr/\Q$delim/ ) or return;

    my $event = Markdent::Event->new(
        type => 'end',
        name => 'strong',
    );

    $self->_markup_event($event);

    return 1;
}

sub _match_emphasis_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/(?:\*|_)/ )
        or return;

    my $event = Markdent::Event->new(
        type       => 'start',
        name       => 'emphasis',
        attributes => { delimiter => $delim },
    );

    $self->_markup_event($event);

    return 1;
}

sub _match_emphasis_end {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    $self->_match_delimiter_end( $text, qr/\Q$delim/ )
        or return;

    my $event = Markdent::Event->new(
        type => 'end',
        name => 'emphasis',
    );

    $self->_markup_event($event);

    return 1;
}

sub _match_code_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/\`+/ )
        or return;

    my $event = Markdent::Event->new(
        type       => 'start',
        name       => 'code',
        attributes => { delimiter => $delim },
    );

    $self->_markup_event($event);

    return 1;
}

sub _match_code_end {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    $self->_match_delimiter_end( $text, qr/\Q$delim/ )
        or return;

    my $event = Markdent::Event->new(
        type => 'end',
        name => 'code',
    );

    $self->_markup_event($event);

    return 1;
}

sub _match_delimiter_start {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    return unless ${$text} =~ /(?: ^ | \P{Letter} \G ) ($delim) (?= \S ) /xgc;

    return $1;
}

sub _match_delimiter_end {
    my $self        = shift;
    my $text        = shift;
    my $delim       = shift;

    return unless ${$text} =~ /[^\s\\] \G $delim (?= \P{Letter} | \z ) /xgc;

    return 1;
}

sub _match_html {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ /\G (< [^>]+ >)/xgc;

    my $event = Markdent::Event->new(
        type       => 'inline',
        name       => 'html',
        attributes => { content => $1 },
    );

    $self->_markup_event($event);

    return 1;
}

# Stolen from Text::Markdown
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

sub _match_link {
    my $self = shift;
    my $text = shift;

    return unless
        ${$text} =~ /\G
                     \[ ($nested_brackets) \]  # link text
                     (?:
                       \(
                         ( [^\s]+ )            # an inline URI
                         (?:
                           \s+
                           ( ["'] )
                           ([^\3]+)            # an optional quoted title
                           \3
                         )?
                         \s*
                       \)
                       |
                       \s*
                       \[ ( [^]]* ) \]         # an id (can be empty)
                     )
                    /xgc;

    my $link_text = $1;

    my %attr;
    if ( defined $2 ) {
        $attr{uri}   = $2;
        $attr{title} = $4
            if defined $4;
    }
    else {
        $attr{id} = $5 || $1;
    }

    my $start = Markdent::Event->new(
        type       => 'start',
        name       => 'link',
        attributes => \%attr,
    );

    $self->_markup_event($start);

    $self->_parse_text( \$link_text );

    my $end = Markdent::Event->new(
        type => 'end',
        name => 'link',
    );

    $self->_markup_event($end);

    return 1;
}

sub _match_image {
    my $self = shift;
    my $text = shift;

    return;
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
                       (?= < [^>]+ > )    #   an HTML tag
                       |
                       \z                 #   or the end of the string
                     )
                    /xgc;

    $self->_print_debug( "Interpreting as plain text\n\n[$1]\n" )
        if $self->debug();

    my $plain = $self->_unescape_plain_text($1);

    $self->_save_span_text($plain);

    return 1;
}

sub _unescape_plain_text {
    my $self  = shift;
    my $plain = shift;

    $plain =~ s/\\([\`*_{}[\]()#+\-.!])/$1/g;

    return $plain;
}

sub _markup_event {
    my $self = shift;
    my $event = shift;

    $self->_event_for_text_buffer();

    $self->_print_debug( 'Found markup: ' . $event->event_name() . "\n" )
        if $self->debug();

    $self->_add_pending_event($event);

    $self->_convert_invalid_start_events_to_text()
        if $event->type() eq 'end';
}

sub _event_for_text_buffer {
    my $self = shift;

    return unless $self->_has_span_text_buffer();

    my $event = Markdent::Event->new(
        type       => 'inline',
        name       => 'text',
        attributes => { content => $self->_span_text_buffer() },
    );

    $self->_add_pending_event($event);

    $self->_clear_span_text_buffer();
}

sub _convert_invalid_start_events_to_text {
    my $self    = shift;
    my $is_done = shift;

    # We want to operate directly on the reference so we can convert
    # individual events in place
    my $events = $self->__pending_events();

    my @starts;
EVENT:
    for my $i ( 0 .. $#{$events} ) {
        my $event = $events->[$i];

        if ( $event->type eq 'start' ) {
            push @starts, [ $i, $event ];
        }
        elsif ( $event->type() eq 'end' ) {
            while ( my $start = pop @starts ) {
                next EVENT
                    if $start->[1]->name() eq $event->name();

                $events->[ $start->[0] ]
                    = $self->_convert_start_event_to_text( $start->[1] );
            }
        }
    }

    return unless $is_done;

    for my $start (@starts) {
        $events->[ $start->[0] ] = $self->_convert_start_event_to_text( $start->[1] );
    }
}

sub _convert_start_event_to_text {
    my $self  = shift;
    my $event = shift;

    $self->_print_debug( 'Found bad start event for '
            . $event->name()
            . q{ with "}
            . $event->attributes()->{delimiter}
            . q{" as the delimiter}
            . "\n" )
        if $self->debug();

    return Markdent::Event->new(
        type       => 'inline',
        name       => 'text',
        attributes => {
            content           => $event->attributes()->{delimiter},
            '!converted_from' => $event->event_name(),
        },
    );
}

sub _merge_consecutive_text_events {
    my $self = shift;

    my $events = $self->__pending_events();

    my $merge_start;

    my @to_merge;
    for my $i ( 0 .. $#{$events} ) {
        my $event = $events->[$i];

        if ( $event->name eq 'text' ) {
            $merge_start = $i
                unless defined $merge_start;
        }
        else {
            push @to_merge, [ $merge_start, $i - 1 ]
                if defined $merge_start && $i - 1 > $merge_start;

            undef $merge_start;
        }
    }

    # If $merge_start is still defined, then the last event was a text event
    # which may need to be merged.
    push @to_merge, [ $merge_start, $#{$events} ]
        if defined $merge_start && $#{$events} > $merge_start;

    my $already_merged = 0;
    for my $pair (@to_merge) {
        $pair->[0] -= $already_merged;
        $pair->[1] -= $already_merged;

        $self->_splice_merged_text_event( $events, @{$pair} );

        $already_merged += $pair->[1] - $pair->[0];
    }
}

sub _splice_merged_text_event {
    my $self   = shift;
    my $events = shift;
    my $start  = shift;
    my $end    = shift;

    my @to_merge = map { $_->attributes()->{content} } @{$events}[ $start .. $end ];

    $self->_print_debug( "Merging consecutive text events ($start-$end) for: \n"
            . ( join q{}, map {"  - [$_]\n"} @to_merge ) )
        if $self->debug();

    my $merged_text = join q{}, @to_merge;

    my $event = Markdent::Event->new(
        type       => 'inline',
        name       => 'text',
        attributes => {
            content        => $merged_text,
            '!merged_from' => \@to_merge,
        },
    );

    splice @{$events}, $start, ( $end - $start ) + 1, $event;
}

sub _debug_pending_events {
    my $self = shift;
    my $desc = shift;

    return unless $self->debug();

    my $msg = "Pending event stream $desc:\n";

    for my $event ( $self->_pending_events() ) {
        $msg .= $event->debug_dump() . "\n";
    }

    $self->_print_debug($msg);
}

use re 'eval';

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
