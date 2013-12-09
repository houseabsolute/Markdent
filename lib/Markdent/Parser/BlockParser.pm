package Markdent::Parser::BlockParser;

use strict;
use warnings;
use namespace::autoclean;

use Digest::SHA1 qw( sha1_hex );
use Markdent::Event::StartDocument;
use Markdent::Event::EndDocument;
use Markdent::Event::StartBlockquote;
use Markdent::Event::EndBlockquote;
use Markdent::Event::StartHeader;
use Markdent::Event::EndHeader;
use Markdent::Event::StartListItem;
use Markdent::Event::EndListItem;
use Markdent::Event::StartOrderedList;
use Markdent::Event::EndOrderedList;
use Markdent::Event::StartParagraph;
use Markdent::Event::EndParagraph;
use Markdent::Event::StartUnorderedList;
use Markdent::Event::EndUnorderedList;
use Markdent::Event::HorizontalRule;
use Markdent::Event::HTMLBlock;
use Markdent::Event::HTMLCommentBlock;
use Markdent::Event::Preformatted;
use Markdent::Regexes qw( :block $HTMLComment );
use Markdent::Types qw( Str Int Bool ArrayRef HashRef );

use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

with 'Markdent::Role::BlockParser';

has __html_blocks => (
    traits   => ['Hash'],
    is       => 'ro',
    isa      => HashRef [Str],
    default  => sub { {} },
    init_arg => undef,
    handles  => {
        _save_html_block => 'set',
        _get_html_block  => 'get',
    },
);

has _list_level => (
    traits   => ['Counter'],
    is       => 'rw',
    isa      => Int,
    default  => 0,
    init_arg => undef,
    handles  => {
        '_inc_list_level' => 'inc',
        '_dec_list_level' => 'dec',
    },
);

has _list_item_is_paragraph => (
    traits   => ['Bool'],
    is       => 'ro',
    isa      => Bool,
    default  => 0,
    init_arg => undef,
    handles  => {
        _treat_list_item_as_paragraph => 'set',
        _treat_list_item_as_line      => 'unset',
    },
);

has _ordered_list_ordinal_for_level => (
    traits => ['Hash'],
    is       => 'rw',
    isa      => HashRef,
    default  => sub { {} },
    init_arg => undef,
);

has _list_is_ordered => (
    traits   => ['Bool'],
    is       => 'ro',
    isa      => Bool,
    default  => 0,
    init_arg => undef,
    handles  => {
        _treat_list_as_ordered   => 'set',
        _treat_list_as_unordered => 'unset',
    },
);

sub parse_document {
    my $self = shift;
    my $text = shift;

    $self->_treat_list_item_as_line();

    $self->_hash_html_blocks($text);

    $self->_span_parser()->extract_link_ids($text);

    $self->_parse_text($text);
}

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

        ${$text} =~ s{
                 ( $BlockStart )
                 (
                   ^ < ($block_names_re) [^>]* >
                   (?s: .+? )
                   (?: </ \3 > \n )+             # This catches repetitions of the final closing block
                 )
                 $BlockEnd
                }
                { ( $1 || q{} ) . $self->_hash_and_save_html($2) }egxm;


        # We need to treat <hr/> tags as blocks as well, but they don't have
        # an ending delimiter.
        ${$text} =~ s{
                 ( $BlockStart )
                 (<hr\ */?>)
                }
                { ( $1 || q{} ) . $self->_hash_and_save_html($2) }egxm;

        return;
    }
}

sub _hash_and_save_html {
    my $self = shift;
    my $html = shift;

    my $sha1 = lc sha1_hex($html);

    $self->_save_html_block( $sha1 => $html );

    return 'html:' . $sha1 . "\n";
}

sub _parse_text {
    my $self = shift;
    my $text = shift;

    my $last_pos;
    my $x = 1;
PARSE:
    while (1) {
        if ( $self->debug() && pos ${$text} ) {
            $self->_print_debug( "Remaining text:\n[\n"
                    . substr( ${$text}, pos ${$text} )
                    . "\n]\n" );
        }

        if ( ${$text} =~ / \G \p{Space}* \z /xgc ) {
            last;
        }

        my $current_pos = pos ${$text} || 0;
        if ( defined $last_pos && $last_pos == $current_pos ) {
            my $msg
                = "About to enter an endless loop (pos = $current_pos)!\n";
            $msg .= "\n";
            $msg .= substr( ${$text}, $last_pos );
            $msg .= "\n";

            die $msg;
        }

        my @look_for = $self->_possible_block_matches();

        $self->_debug_look_for(@look_for);

        for my $block (@look_for) {
            my $meth = '_match_' . $block;

            $self->$meth($text)
                and next PARSE;
        }

        $last_pos = pos ${$text} || 0;
    }
}

sub _possible_block_matches {
    my $self = shift;

    my @look_for;

    push @look_for, qw( hashed_html horizontal_rule )
        unless $self->_list_level();

    push @look_for, qw(
        html_comment
        atx_header
        two_line_header
        blockquote
        preformatted
        list
    );

    push @look_for, 'list_item'
        if $self->_list_level();

    push @look_for, 'paragraph';

    return @look_for;
}

sub _match_hashed_html {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                ^
                                (
                                  html:([0-9a-f]{40})
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

    $self->_send_event(
        HTMLBlock => html => $html,
    );

    return 1;
}

sub _match_html_comment {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $EmptyLine*?
                                ^
                                \p{SpaceSeparator}{0,3}
                                $HTMLComment
                                $HorizontalWS*
                                \n
                              /xmgc;

    my $comment = $1;

    $self->_debug_parse_result(
        $comment,
        'html comment block',
    ) if $self->debug();

    $self->_detab_text( \$comment );

    $self->_send_event( HTMLCommentBlock => text => $comment );

    return 1;
}

my $AtxHeader = qr/ ^
                    (\#{1,6})
                    (
                      $HorizontalWS*
                      \S
                      .+?
                    )
                    (?:
                      $HorizontalWS*
                      \#+
                    )?
                    \n
                  /xm;

sub _match_atx_header {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                (?:$EmptyLines)?
                                ($AtxHeader)
                              /xmgc;

    my $level       = length $2;
    my $header_text = $3 . "\n";

    $self->_debug_parse_result(
        $1,
        'atx header',
        [ level => $level ],
    ) if $self->debug();

    $header_text =~ s/^$HorizontalWS*//;

    $self->_header( $level, $header_text );

    return 1;
}

my $TwoLineHeader = qr/  ^
                         (
                           $HorizontalWS*
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

    $self->_send_event( StartHeader => level => $level );

    $self->_span_parser()->parse_block($text);

    $self->_send_event( EndHeader => level => $level );

    return 1;
}

my $HorizontalRule = qr/ ^
                         (
                           \p{SpaceSeparator}{0,3}
                           (?:
                             (?: \* \p{SpaceSeparator}? ){3,}
                             |
                             (?: -  \p{SpaceSeparator}? ){3,}
                             |
                             (?: _  \p{SpaceSeparator}? ){3,}
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

    $self->_send_event('HorizontalRule');

    return 1;
}

sub _match_blockquote {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                (
                                  ^
                                  >
                                  $HorizontalWS*
                                  \S
                                  (?:
                                    .*
                                    \n
                                  )+?
                                )
                                (?=
                                  $EmptyLine  # ... an empty line
                                  ^
                                  (?=
                                    \S            # ... followed by content in column 1
                                  )
                                  (?!             # ... which is not
                                    >             # ... a blockquote
                                    $HorizontalWS*
                                    \S
                                  )
                                  |
                                  \s*         # or end of the document
                                  \z
                                )
                              /xmgc;

    my $bq = $1;

    $self->_debug_parse_result(
        $bq,
        'blockquote',
    ) if $self->debug();

    $self->_send_event('StartBlockquote');

    $bq =~ s/^>(?: \p{SpaceSeparator} | \t )?//gxm;

    # Even if the blockquote is inside a list, we want to look for paragraphs,
    # not list items.
    my $list_level = $self->_list_level();
    $self->_set_list_level(0);

    # Dingus treats a new blockquote level as starting a new paragraph as
    # well. If we treat each change of blockquote level as starting a new
    # sub-document, we get the same behavior.
    for my $chunk (
        $self->_split_chunks_on_regex(
            $bq, qr/^>(?: \p{SpaceSeparator} | \t )*\S/xm
        )
        ) {

        $self->_parse_text( \$chunk );
    }

    $self->_set_list_level($list_level);

    $self->_send_event('EndBlockquote');

    return 1;
}

my $PreLine = qr/ ^
                  (?:
                    \p{spaceSeparator}{4,}
                    |
                    \t
                  )
                  $HorizontalWS*
                  \S
                  .*
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

    $pre =~ s/^(?:\p{SpaceSeparator}{4}|\t)//gm;

    $self->_detab_text( \$pre );

    $self->_send_event( Preformatted => text => $pre );

    return 1;
}

my $Bullet = qr/ (?:
                   \p{SpaceSeparator}{0,3}
                   (
                     [\+\*\-]           # unordered list bullet
                     |
                     \d+\.              # ordered list number
                   )
                 )
                 $HorizontalWS+
               /xm;

sub _list_re {
    my $self = shift;

    my $block_start;

    if ( $self->_list_level() ) {
        $block_start = qr/(?: (?<= \n ) | $EmptyLines )/xm;
    }
    else {
        $block_start = qr/ $BlockStart /xm;
    }

    my $list = qr/ $block_start
                   (
                     $Bullet
                     (?: .* \n )+?
                   )
                 /xm;

    return $list;
}

sub _match_list {
    my $self = shift;
    my $text = shift;

    my $list_re = $self->_list_re();

    return unless ${$text} =~ / \G
                                $list_re
                                (?=           # list ends with
                                  $EmptyLine  # ... an empty line
                                  (?:
                                    (?=
                                      $HorizontalRule  # ... followed by a horizontal rule
                                    )
                                    |
                                    (?=
                                      \S               # ... or followed by content in column 1
                                    )
                                    (?!                # ... which is not
                                      $Bullet          # ... a bullet
                                    )
                                  )
                                  |
                                  \s*         # or end of the document
                                  \z
                                )
                              /xmgc;

    my $list   = $1;
    my $bullet = $2;

    my $type = $bullet =~ /\d/ ? 'OrderedList' : 'UnorderedList';

    $self->_debug_parse_result(
        $list,
        $type,
    ) if $self->debug();

    $self->_send_event( 'Start' . $type );

    $self->_inc_list_level();

    if ( $type eq 'OrderedList' ) {
        $self->_ordered_list_ordinal_for_level->{ $self->_list_level } = 1;
        $self->_treat_list_as_ordered;
    }
    else {
        $self->_treat_list_as_unordered;
    }

    my @items = $self->_split_list_items($list);

    $self->_handle_list_items(@items);

    $self->_dec_list_level();

    $self->_send_event( 'End' . $type );

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

sub _handle_list_items {
    my $self  = shift;
    my @items = @_;

    for my $item (@items) {
        $item =~ s/^$Bullet//;
        my $bullet = $1;
        if ( $self->_list_is_ordered ) {
            $bullet = $self->_ordered_list_ordinal_for_level->{ $self->_list_level };
            $bullet .= q{.};
            $self->_ordered_list_ordinal_for_level->{ $self->_list_level }++;
        }

        $self->_send_event( StartListItem => bullet => $bullet );

        # This strips out indentation from any lines beyond the first. This
        # causes the block parser to see a sub-list as starting a new list
        # when it parses the entire item for blocks.
        $item =~ s/(?<=\n)^ (?: \p{SpaceSeparator}{4} | \t )//xgm;

        $self->_print_debug("Parsing list item for blocks:\n[$item]\n")
            if $self->debug();

        # This is a hack to ensure that the last item in a loose list (each
        # item is a paragraph) also is treated as a paragraph, not just a list
        # item.
        if ( $item eq $items[-1] ) {
            if (   @items > 1
                && $items[-2] =~ /^$EmptyLine\z/m ) {

                $self->_print_debug(
                    "Treating last list item as a paragraph because previous item ends with empty line\n"
                ) if $self->debug();

                $self->_treat_list_item_as_paragraph();
            }
            else {
                $self->_treat_list_item_as_line();
            }
        }
        elsif ( $item =~ /^$EmptyLine\z/m ) {
            $self->_print_debug(
                "Treating item as a paragraph because it ends with empty line\n"
            ) if $self->debug();

            $self->_treat_list_item_as_paragraph();
        }
        else {
            $self->_treat_list_item_as_line();
        }

        $self->_parse_text( \$item );

        $self->_send_event('EndListItem');
    }
}

# A list item matches multiple lines of text without any separating
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
                                  .*
                                  \n
                                )+?)
                                (?=
                                  ^
                                  $Bullet
                                  |
                                  ^
                                  > \p{SpaceSeparator}*
                                  \S
                                  .*
                                  \n
                                  |
                                  \z
                                )
                              /xmgc;

    $self->_debug_parse_result(
        $1,
        'list_item',
    ) if $self->debug();

    $self->_send_event('StartParagraph')
        if $self->_list_item_is_paragraph();

    $self->_span_parser()->parse_block($1);

    $self->_send_event('EndParagraph')
        if $self->_list_item_is_paragraph();

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
                                  .*
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

    $self->_send_event('StartParagraph');

    $self->_span_parser()->parse_block($1);

    $self->_send_event('EndParagraph');

    return 1;
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
            $in_regex  = 0;
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

# ABSTRACT: Block parser for standard Markdown

__END__

=pod

=head1 DESCRIPTION

This class parses blocks for the standard Markdown dialect (as defined by
Daring Fireball and mdtest).

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Parser::BlockParser->new( handler => $handler, span_parser => $span_parser )

Creates a new block parser object. You must provide a span parser object.

=head2 $block_parser->parse_document(\$markdown)

This method takes a reference to a markdown string and parses it for
blocks. Each block which contains text (except preformatted text) will be
parsed for span-level markup using this object's C<span_parser>.

=head1 ROLES

This class does the L<Markdent::Role::BlockParser>,
L<Markdent::Role::AnyParser>, and L<Markdent::Role::DebugPrinter> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
