package Markdent::Dialect::Standard::BlockParser;

use strict;
use warnings;

our $VERSION = '0.01';

use Digest::SHA1 qw( sha1_hex );
use Markdent::Types qw( Str Int Bool ArrayRef HashRef );
use MooseX::Params::Validate qw( validated_list );
use re 'eval';
use Text::Balanced qw( gen_extract_tagged );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

with 'Markdent::Role::BlockParser';

has __buffered_lines => (
    traits   => ['Array'],
    is       => 'ro',
    isa      => ArrayRef[Str],
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

has __html_blocks => (
    traits   => ['Hash'],
    is       => 'ro',
    isa      => HashRef[Str],
    default  => sub { {} },
    init_arg => undef,
    handles  => {
        _save_html_block => 'set',
        _get_html_block  => 'get',
    },
);

has _blockquote_level => (
    is       => 'rw',
    isa      => Int,
    default  => 0,
    init_arg => undef,
);

has _list_level => (
    is       => 'rw',
    isa      => Int,
    default  => 0,
    init_arg => undef,
);

has _in_preformatted => (
    is       => 'rw',
    isa      => Bool,
    default  => 0,
    init_arg => undef,
);

has _previous_line_was_empty => (
    is       => 'rw',
    isa      => Bool,
    default  => 0,
    init_arg => undef,
);

sub parse_document {
    my $self = shift;
    my $text = shift;

    $self->_set_previous_line_was_empty(0);

    $self->_hash_html_blocks($text);

    my @lines = map { chomp; $_ } split /\n/, ${$text};

    for my $i ( 0 .. $#lines ) {
        my $line = $lines[$i];

        $self->_parse_line($line);
        $self->_set_previous_line_was_empty( $line =~ /^\s*$/ ? 1 : 0 );
    }

    $self->_finalize_document();
}

{
    # Stolen from Text::Markdown, along with the whole "extract and replace with
    # hash" concept.
    my $blocks_re = qr{
      p         |  div     |  h[1-6]  |  blockquote  |  pre       |  table  |
      dl        |  ol      |  ul      |  script      |  noscript  |  form   |
      fieldset  |  iframe  |  math    |  ins         |  del
    }xi;

    my $nested_tags;
    $nested_tags = qr{ (
                         ^ < ($blocks_re) [^>]* >
                         (?:
                           (?{{ $nested_tags }})
                           |
                           .+?
                         )
                         ^ </ \g{-1} >
                       )
                     }xims;

    sub _hash_html_blocks {
        my $self = shift;
        my $text = shift;

        ${$text}
            =~ s{ ( \A\n? | \n\n ) $nested_tags (?= \n\n | \n?\z ) }
                { ( $1 || q{} ) . $self->_hash_and_save_html($2) }egx;

        return;
    }
}

sub _hash_and_save_html {
    my $self = shift;
    my $html = shift;

    my $sha1 = sha1_hex($html);

    $self->_save_html_block( $sha1 => $html );

    return 'html:' . $sha1;
}

sub _parse_line {
    my $self = shift;
    my $line = shift;

    $self->_maybe_close_open_blocks($line);

    $self->_match_empty_line($line) and return;

    $self->_parse_line_contents($line);

    return;
}

# This method can be called mid-line (like in a block quote or list item) to
# look for further block-level contents. The _parse_line method can only be
# called once per line.
sub _parse_line_contents {
    my $self = shift;
    my $line = shift;

    $self->_match_hashed_html($line) and return 1;

    $self->_match_atx_header($line) and return 1;

    $self->_match_two_line_header($line) and return 1;

    $self->_match_horizontal_rule($line) and return 1;

    $self->_match_blockquote($line) and return 1;

    $self->_match_preformatted($line) and return 1;

    $self->_add_line_to_buffer($line);

    return;
}

sub _match_empty_line {
    my $self = shift;
    my $line = shift;

    return unless $self->_line_is_empty($line);

    return if $self->_in_preformatted();

    $self->_print_debug("Found an empty line, flushing the buffer\n")
        if $self->debug();

    $self->_flush_buffer();

    return 1;
}

sub _line_is_empty {
    return $_[1] =~ /^\s*$/;
}

sub _match_hashed_html {
    my $self = shift;
    my $line = shift;

    return unless $line =~ /html:(.{40})/;

    my $html = $self->_get_html_block($1);

    return unless defined $html;

    $self->_debug_parse_result(
        $line,
        'hashed html',
    ) if $self->debug();

    $self->handler()->handle_event(
        type       => 'inline',
        name       => 'html_block',
        attributes => { content => $html },
    );

    return 1;
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

    return if $self->_has_buffer() && ! $self->_previous_line_was_empty();

    $self->_debug_parse_result(
        $line,
        'horizontal rule',
    ) if $self->debug();

    $self->_horizontal_rule();

    return 1;
}

sub _match_preformatted {
    my $self = shift;
    my $line = shift;

    my $leading_space = $self->_list_level * 4;

    return unless $line =~ / ^
                             (
                               [ ]{$leading_space}
                               [ ]{4,}
                               .+
                             )
                           /xm;

    my $text = $1;

    $self->_flush_buffer()
        unless $self->_in_preformatted();

    $self->_debug_parse_result(
        $line,
        'preformatted',
    ) if $self->debug();

    $text =~ s/^[ ]{$leading_space}[ ]{4}//;

    $self->_set_in_preformatted(1);

    $self->_add_line_to_buffer($text);

    return 1;
}

sub _match_blockquote {
    my $self = shift;
    my $line = shift;

    my $leading_space = $self->_list_level * 4;

    return unless $line =~ / ^
                             [ ]{$leading_space}  # one indent level per list level
                             (?: [ ]{,3} )?       # up to 3 spaces
                             (>(?:\s*>)?)
                             ([^\n]+)
                           /xm;

    my $bq   = $1;
    my $text = $2;

    my $level = $bq =~ tr/>/>/;

    $self->_flush_buffer()
        if $level != $self->_blockquote_level();

    $self->_debug_parse_result(
         $line,
        'blockquote',
        [ level => $level ],
    ) if $self->debug();

    if ( $level > $self->_blockquote_level() ) {
        $self->_start_blockquote()
            for $self->_blockquote_level() + 1 .. $level;
    }
    elsif ( $level < $self->_blockquote_level() ) {
        $self->_end_blockquote() for $level + 1 .. $self->_blockquote_level();
    }

    $self->_set_blockquote_level($level);

    $text =~ s/^\s+//;

    $self->_parse_line_contents($text);

    return 1;
}

sub _finalize_document {
    my $self = shift;

    $self->_close_open_preformatted();

    $self->_flush_buffer('always');

    $self->_close_open_blockquotes();
}

sub _flush_buffer {
    my $self   = shift;
    my $always = shift;

    return unless $self->_has_buffer();

    return unless $always || ! $self->_previous_line_was_empty();

    if ( $self->debug() ) {
        if ( $always ) {
            $self->_print_debug("Flushing the buffer unconditionally\n")
        }
        else {
            $self->_print_debug("Flushing the buffer because the previous line had content\n");
        }
    }

    $self->_paragraph( $self->_buffered_lines() );

    $self->_clear_buffer();
}

sub _maybe_close_open_blocks {
    my $self = shift;
    my $line = shift;

    return
        unless $self->_previous_line_was_empty()
            && $line =~ /^[ ]{0,3}\S/;

    $self->_print_debug("Found content after an empty line, checking for open blocks which need closing\n$line\n")
        if $self->debug();

    if ( $self->_in_preformatted() ) {
        return if $line =~ /^\s*$/;

        my $leading_space = $self->_list_level() * 4;

        return if $line =~ /^[ ]{$leading_space}[ ]{4,}\S/;

        $self->_close_open_preformatted();
    }

    if ( $self->_blockquote_level() ) {
        return if $line =~ /^>(\s*>)*\s*\S/;

        $self->_print_debug("  ... closing any open blockquotes\n")
            if $self->debug();

        $self->_close_open_blockquotes();
    }
}

sub _close_open_preformatted {
    my $self = shift;

    return unless $self->_in_preformatted();

    $self->handler()->handle_event(
        type       => 'start',
        name       => 'preformatted',
    );

    my @buffer = $self->_buffered_lines();
    pop @buffer while defined $buffer[-1] && $self->_line_is_empty( $buffer[-1] );

    $self->handler()->handle_event( type => 'inline',
                                    name => 'text',
                                    attributes => { content => $_ . "\n" } )
        for @buffer;

    $self->_clear_buffer();

    $self->handler()->handle_event(
        type       => 'end',
        name       => 'preformatted',
    );

    $self->_set_in_preformatted(0);
}

sub _close_open_blockquotes {
    my $self = shift;

    return unless $self->_blockquote_level();

    $self->_end_blockquote()
        for 1 .. $self->_blockquote_level();

    $self->_set_blockquote_level(0);
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
    my $self = shift;
    my @lines = grep {/\S/} @_;

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

sub _start_blockquote {
    my $self = shift;

    $self->handler()->handle_event(
        type => 'start',
        name => 'blockquote',
    );
}

sub _end_blockquote {
    my $self = shift;

    $self->handler()->handle_event(
        type => 'end',
        name => 'blockquote',
    );
}

__PACKAGE__->meta()->make_immutable();

1;
