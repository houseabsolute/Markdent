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

has _list_level => (
    traits  => ['Counter'],
    is      => 'rw',
    isa     => Int,
    default => 0,
    handles => {
        '_inc_list_level' => 'inc',
        '_dec_list_level' => 'dec',
    },
);

sub parse_document {
    my $self = shift;
    my $text = shift;

    $self->_hash_html_blocks($text);

    $self->_parse_text($text);
}

my $EmptyLine = qr/(?: ^ \p{SpaceSeparator}* \n ) /xm;
my $EmptyLines = qr/ (?: $EmptyLine )+ /xm;

my $BlockStart = qr/(?: \A | $EmptyLines )/xm;
my $BlockEnd = qr/(?=(?: $EmptyLines | \z ) )/xm;

{
    # Stolen from Text::Markdown, along with the whole "extract and replace
    # with hash" concept.
    my $block_names_re = qr{
      p         |  div     |  h[1-6]  |  blockquote  |  pre       |  table  |
      dl        |  ol      |  ul      |  script      |  noscript  |  form   |
      fieldset  |  iframe  |  math    |  ins         |  del
    }xi;

    sub _hash_html_blocks {
        my $self = shift;
        my $text = shift;

        ${$text}
            =~ s{
                 ( $BlockStart )
                 (
                   ^ < ($block_names_re) [^>]* >
                   (?s: .+? )
                   (?: ^ </ \3 > \n )+             # This catches repetitions of the final closing block
                 )
                 $BlockEnd
                }
                { ( $1 || q{} ) . $self->_hash_and_save_html($2) }egxm;

        return;
    }
}

sub _hash_and_save_html {
    my $self = shift;
    my $html = shift;

    my $sha1 = sha1_hex($html);

    $self->_save_html_block( $sha1 => $html );

    return 'html:' . $sha1 . "\n";
}

sub _parse_text {
    my $self = shift;
    my $text = shift;

    my $last_pos;

    while (1) {
        if ( $self->debug() && pos ${$text} ) {
            $self->_print_debug( "Remaining text:\n[\n"
                    . substr( ${$text}, pos ${$text} )
                    . "\n]\n" );
        }

        if ( ${$text} =~ / \G \p{Space}* \z /xgc ) {
            last;
        }

        die 'About to enter an endless loop!'
            if $last_pos && $last_pos == pos ${$text};

        $self->_match_hashed_html($text) and next;

        $self->_match_atx_header($text) and next;

        $self->_match_two_line_header($text) and next;

        $self->_match_horizontal_rule($text) and next;

        $self->_match_blockquote($text) and next;

        $self->_match_preformatted($text) and next;

        $self->_match_list($text) and next;

        if ( $self->_list_level() ) {
            $self->_match_list_item($text) and next;
        }

        $self->_match_paragraph($text) and next;

        $last_pos = pos ${$text};
    }
}

sub _match_hashed_html {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                ^
                                (
                                  html:(.{40})
                                  \n
                                )
                                $BlockEnd
                              /xmgc;

    my $html = $self->_get_html_block($2);

    return unless defined $html;

    $self->_debug_parse_result(
        $1,
        'hashed html',
    ) if $self->debug();

    $self->handler()->handle_event(
        type       => 'inline',
        name       => 'html_block',
        attributes => { content => $html },
    );

    return 1;
}

my $AtxHeader = qr/ ^
                    (\#{1,6})
                    (
                      \p{SpaceSeparator}*
                      \S
                      .+
                      \n
                    )
                  /xm;

sub _match_atx_header {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                (?:$EmptyLines)?
                                ($AtxHeader)
                              /xmgc;

    my $level       = length $2;
    my $header_text = $3;

    $self->_debug_parse_result(
        $1,
        'atx header',
        [ level => $level ],
    ) if $self->debug();

    $header_text =~ s/^\p{SpaceSeparator}*//;

    $self->_header( $level, $header_text );

    return 1;
}

my $TwoLineHeader = qr/  ^
                         (
                           \p{SpaceSeparator}*   # horizontal ws
                           \S                    # must have some non-ws
                           .+                    # anything else
                           \n
                         )
                         ^(=+|-+)                # underline marking a header
                         \n
                      /xm;

sub _match_two_line_header {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                (?:$EmptyLines)?
                                ($TwoLineHeader)
                              /xmgc;

    my $level = substr( $3, 0, 1 ) eq '=' ? 1 : 2;

    $self->_debug_parse_result(
        $1,
        'two-line header',
        [ level => $level ],
    ) if $self->debug();

    $self->_header( $level, $2 );

    return 1;
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

    return 1;
}

my $HorizontalRule = qr/ ^
                         (
                           \p{SpaceSeparator}{0,3}
                           (?:
                             (?: \* \p{SpaceSeparator}* ){3,}
                             |
                             (?: -  \p{SpaceSeparator}* ){3,}
                           )
                           \n
                         )
                       /xm;

sub _match_horizontal_rule {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                (?:$EmptyLines)?
                                $HorizontalRule
                              /xmgc;

    $self->_debug_parse_result(
        $1,
        'horizontal rule',
    ) if $self->debug();

    $self->handler()->handle_event(
        type => 'inline',
        name => 'hr',
    );

    return 1;
}

sub _match_blockquote {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                ((?:
                                  ^
                                  > \p{SpaceSeparator}*
                                  \S
                                  .+
                                  \n
                                )+)
                                $BlockEnd
                              /xmgc;

    my $bq = $1;

    $self->_debug_parse_result(
         $bq,
        'blockquote',
    ) if $self->debug();


    $self->handler()->handle_event(
        type => 'start',
        name => 'blockquote',
    );

    $bq =~ s/^>\p{SpaceSeparator}{0,3}//gm;

    # Dingus treats a new blockquote level as starting a new paragraph as
    # well. If we treat each change of blockquote level as starting a new
    # sub-document, we get the same behavior.
    for my $chunk (
        $self->_split_chunks_on_regex( $bq, qr/^>\p{SpaceSeparator}*\S/m ) ) {

        $self->_parse_text( \$chunk );
    }

    $self->handler()->handle_event(
        type => 'end',
        name => 'blockquote',
    );

    return 1;
}

my $PreLine = qr/ ^
                  \p{spaceSeparator}{4,}
                  \S
                  .+
                  \n
                /xm;

sub _match_preformatted {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                (
                                  (?:
                                    $PreLine
                                    (?:$EmptyLine)*
                                  )*
                                  $PreLine
                                )
                             /xmgc;

    my $pre = $1;

    $self->_debug_parse_result(
        $pre,
        'preformatted',
    ) if $self->debug();

    $pre =~ s/^\p{SpaceSeparator}{4}//g;

    $self->handler()->handle_event(
        type       => 'inline',
        name       => 'preformatted',
        attributes => { content => $pre },
    );

    return 1;
}

my $Bullet = qr/ (?:
                   \p{SpaceSeparator}{0,3}
                   ( [\*\-\+] )       # unordered list bullet
                   |
                   ( \d+\. )          # ordered list number
                 )
                 \p{SpaceSeparator}+
               /xm;

my $List = qr/ $Bullet
               (?: .* \n )+?
             /xm;

sub _list_re {
    my $self = shift;

    my $list_start;
    if ( $self->_list_level() ) {
        my $space_width = $self->_list_level() * 4;
        $list_start = qr/^ \p{SpaceSeparator}{$space_width} /xm;
    }
    else {
        $list_start = qr/ $BlockStart ^ /xm;
    }

    return qr/$list_start($List)/;
}

sub _match_list {
    my $self = shift;
    my $text = shift;

    my $list_re = $self->_list_re();

    return unless ${$text} =~ / \G
                                $list_re
                                (?=           # list ends with
                                  $EmptyLine  # ... an empty line
                                  ^
                                  (?=
                                    \S            # ... followed by content in column 1
                                  )
                                  (?!             # ... which is not
                                    $Bullet       # ... a bullet
                                  )
                                  |
                                  \s*         # or end of the document
                                  \z
                                )
                              /xmgc;

    my $list = $1;
    my $type = defined $2 ? 'unordered_list' : 'ordered_list';

    $self->_debug_parse_result(
        $list,
        $type,
    ) if $self->debug();

    $self->handler()->handle_event(
        type => 'start',
        name => $type,
    );

    $self->_inc_list_level();

    for my $item ( $self->_split_list_items($list) ) {
        $self->handler()->handle_event(
            type => 'start',
            name => 'list_item',
        );

        $item =~ s/^$Bullet//;
        $item =~ s/^\p{SpaceSeparator}{1,4}//;

        $self->_parse_text( \$item );

        $self->handler()->handle_event(
            type => 'end',
            name => 'list_item',
        );
    }

    $self->_dec_list_level();

    $self->handler()->handle_event(
        type => 'end',
        name => $type,
    );

    return 1;
}

sub _split_list_items {
    my $self = shift;
    my $list = shift;

    my @items;
    my @chunk;

    for my $line ( split /\n/, $list ) {
        if ( $line =~ /^$Bullet/ && @chunk ) {
            push @items, join q{}, map { $_ . "\n" } @chunk;

            @chunk = ();
        }

        push @chunk, $line;
    }

    push @items, join q{}, map { $_ . "\n" } @chunk
        if @chunk;

    return @items;
}

# A list item matches a multiple lines of text without any separating
# newlines. These lines stop when we see a blockquote or indented list
# bullet. This match is only done inside a list, and lets us distinguish
# between list items which contain paragraphs and those which don't.
sub _match_list_item {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                ((?:
                                  ^
                                  \p{SpaceSeparator}*
                                  \S
                                  .+
                                  \n
                                )+?)
                                (?=
                                  ^
                                  \p{SpaceSeparator}{4}
                                  $Bullet
                                  |
                                  ^
                                  > \p{SpaceSeparator}*
                                  \S
                                  .+
                                  \n
                                  |
                                  \z
                                )
                              /xmgc;

    $self->_debug_parse_result(
        $1,
        'list_item',
    ) if $self->debug();

    $self->span_parser()->parse_markup($1);

    return 1;
}

sub _match_paragraph {
    my $self = shift;
    my $text = shift;

    my $list_re = $self->_list_re();

    # At this point anything that is not an empty line must be a paragraph.
    return unless ${$text} =~ / \G
                                (?:$EmptyLines)?
                                ((?:
                                  ^
                                  \p{SpaceSeparator}*
                                  \S
                                  .+
                                  \n
                                )+?)
                                (?:
                                  $BlockEnd
                                  |
                                  (?= $HorizontalRule )
                                  |
                                  (?= $TwoLineHeader )
                                  |
                                  (?= $AtxHeader )
                                  |
                                  (?= $list_re )
                                )
                              /xmgc;

    $self->_debug_parse_result(
        $1,
        'paragraph',
    ) if $self->debug();

    $self->handler()->handle_event(
        type => 'start',
        name => 'paragraph',
    );

    $self->span_parser()->parse_markup($1);

    $self->handler()->handle_event(
        type => 'end',
        name => 'paragraph',
    );
}

sub _split_chunks_on_regex {
    my $self  = shift;
    my $text  = shift;
    my $regex = shift;

    my @chunks;
    my @chunk;
    my $in_regex = 0;

    for my $line ( split /\n/, $text ) {
        my $new_chunk;

        if ( $in_regex && $line !~ $regex ) {
            $in_regex = 0;
            $new_chunk = 1;
        }
        elsif ( $line =~ $regex && !$in_regex ) {
            $in_regex  = 1;
            $new_chunk = 1;
        }

        if ($new_chunk) {
            push @chunks, join q{}, map { $_ . "\n" } @chunk
                if @chunk;
            @chunk = ();
        }

        push @chunk, $line;
    }

    push @chunks, join q{}, map { $_ . "\n" } @chunk
        if @chunk;

    return @chunks;
}

__PACKAGE__->meta()->make_immutable();

1;
