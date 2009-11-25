package Markdent::Dialect::Theory::BlockParser;

use strict;
use warnings;

our $VERSION = '0.02';

use List::AllUtils qw( insert_after_string );
use Markdent::Event::StartTable;
use Markdent::Event::EndTable;
use Markdent::Event::StartTableHeader;
use Markdent::Event::EndTableHeader;
use Markdent::Event::StartTableBody;
use Markdent::Event::EndTableBody;
use Markdent::Event::StartTableRow;
use Markdent::Event::EndTableRow;
use Markdent::Event::StartTableCell;
use Markdent::Event::EndTableCell;
use Markdent::Regexes qw( $HorizontalWS $EmptyLine $BlockStart $BlockEnd );
use Markdent::Types qw( Bool );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

extends 'Markdent::Dialect::Standard::BlockParser';

has _in_table => (
    traits   => ['Bool'],
    isa      => Bool,
    default  => 0,
    init_arg => undef,
    handles  => {
        _enter_table => 'set',
        _leave_table => 'unset',
    },
);

sub _possible_block_matches {
    my $self = shift;

    my @look_for = $self->SUPER::_possible_block_matches();

    return @look_for if $self->_list_level();

    if ( $self->_in_table() ) {
        insert_after_string 'list', 'table_cell', @look_for;
    }
    else {
        insert_after_string 'list', 'table', @look_for;
    }

    return @look_for;
}

my $TableCaption = qr{ ^
                       $HorizontalWS*
                       \[
                       (.*)
                       \]
                       $HorizontalWS*
                       \n
                     }xm;

my $TableRow = qr{ ^
                   [|]?            # a regular pipe-separated row
                   (?:
                     [^|]*
                     \|
                   )+
                   \n
                   (?:
                     ^
                     :            # a colon-separated row continuation line
                     (?:
                       [^:]*
                       :
                     )+
                   )*             # ... can have 0+ continuation lines
                 }xm;

my $TableHeader = qr{ $TableRow
                      ^
                      \+?
                      (?:
                        -+
                        \+
                      )+
                      (?:
                        -+
                      )?
                      \n
                    }xm;

sub _match_table {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                (
                                  $TableCaption?
                                  ($TableHeader+)
                                  (
                                    (?:
                                      $TableRow
                                      |
                                      $EmptyLine
                                    )+
                                  )
                                  $TableCaption?
                                )
                                $BlockEnd
                              /xmgc;

    $self->_debug_parse_result(
        $1,
        'table',
    ) if $self->debug();

    my $caption = defined $2 ? $2 : $5;

    my $header = $3;
    my $body = $4;

    my @header = $self->_parse_rows( qr/\+?(?:-+\+)+(?:-+)?\n/m, $header );
    $_->{is_header_cell} = 1 for map { @{$_} } @header;

    my @body = $self->_parse_rows( qr/\n/, $body );

    my $first_header_cell_content = $header[0][0]{content};
    unless ( defined $first_header_cell_content
        && $first_header_cell_content =~ /\S/ ) {
        $_->[0]{is_header_cell} = 1 for @body;
    }

    $self->_enter_table();

    my %caption = defined $caption ? ( caption => $caption ) : ();
    $self->_send_event( 'StartTable', %caption );

    $self->_events_for_rows( \@header, 'Header' );
    $self->_events_for_rows( \@body,   'Body' );

    $self->_send_event('EndTable');

    $self->_leave_table();
}

sub _parse_rows {
    my $self = shift;
    my $split_re = shift;
    my $rows = shift;

    my @rows;

    for my $chunk ( split $split_re, $rows ) {
        for my $line ( split /\n/, $chunk ) {
            if ( $line =~ /$EmptyLine/ ) {
                push @rows, undef;
            }
            elsif ( $self->_is_continuation_line($line) ) {

                # If the $TableRow regex is correct, this shouldn't be
                # possible.
                die "Continuation of a row before we've seen a row start?!"
                    unless @rows;

                my @cells = $self->_cells_from_line($line);

                for my $i ( 0 .. $#cells ) {
                    if ( defined $cells[$i]{content}
                        && $cells[$i]{content} =~ /\S/ ) {
                        $rows[-1][$i]{content} .= "\n" . $cells[$i]{content};
                    }
                }
            }
            else {
                push @rows, $self->_cells_from_line($line);
            }
        }
    }

    # Alignments are inherited from the cell above, or they default to "left".
    my %alignments;
    for my $row ( grep { @{$_} } @rows) {
        for my $i ( 0..$#{$row} ) {
            if ( $row->[$i]{alignment} ) {
                $alignments{$i} = $row->[$i]{alignment};
            }
            else {
                $row->[$i]{alignment} = $alignments{$i} || 'left';
            }
        }
    }

    return @rows;
}

sub _is_continuation_line {
    my $self = shift;
    my $line = shift;

    return 0
        if $line
            =~ / (?: \p{SpaceSeparator}+ [|] | [|] \p{SpaceSeparator}+ ) /x;

    return 1
        if $line =~ / (?: \p{SpaceSeparator}+ : | : \p{SpaceSeparator}+ ) /x;

    # a blank line, presumably
    return 0;
}

sub _cells_from_line {
    my $self = shift;
    my $line = shift;

    my @row;
    my $colspan = 1;

    for my $cell ( $self->_split_cells($line) ) {
        # If the first cell is empty (|| ...) we treat it as empty, as opposed
        # to a colspan indicator.
        if ( ! defined $cell && @row ) {
            $row[-1]{colspan}++;
        }
        else {
            push @row, $self->_cell_params( $cell, $colspan );
            $colspan = 1;
        }
    }

    return \@row;
}

sub _split_cells {
    my $self = shift;
    my $line = shift;

    $line =~ s/^[|]|[|]$//g;

    # The inclusion of surrounding space means that we will not split on
    # escaped pipes (which is good).
    return split /\p{SpaceSeparator}+[|]\p{SpaceSeparator}+/, $line;
}

sub _cell_params {
    my $self    = shift;
    my $cell    = shift;
    my $colspan = shift;

    my $alignment;
    my $content;

    if ( defined $cell && $cell =~ /\S/ ) {
        $alignment = $self->_alignment_for_cell($cell);

        ( $content = $cell )
            =~ s/^\p{SpaceSeparator}+|\p{SpaceSeparator}+$//g;
    }

    my %p = (
        colspan => $colspan,
        content => $content,
    );

    $p{alignment} = $alignment
        if defined $alignment;

    return \%p;
}

sub _alignment_for_cell {
    my $self = shift;
    my $cell = shift;

    return 'center'
        if $cell =~ /^\p{SpaceSeparator}{2,}.+?\p{SpaceSeparator}{2,}$/;

    return 'left'
        if $cell =~ /^\p{SpaceSeparator}\S.+?\p{SpaceSeparator}{2,}$/;

    return 'right'
        if $cell =~ /^\p{SpaceSeparator}{2,}.+?\S\p{SpaceSeparator}$/;

    return undef;
}

sub _events_for_rows {
    my $self = shift;
    my $rows = shift;
    my $type = shift;

    my $start = 'StartTable' . $type;
    my $end = 'EndTable' . $type;

    $self->_send_event($start);

    for my $row ( @{$rows} ) {
        if ( ! @{$row} ) {
            $self->_send_event($end);
            $self->_send_event($start);
            next;
        }

        $self->_send_event('StartTableRow');

        for my $cell ( @{$row} ) {
            my $content = delete $cell->{content};

            $self->_send_event(
                'StartTableCell',
                %{$cell}
            );

            # If the content has newlines, it should be matched as a
            # block-level construct (blockquote, list, etc), but to make that
            # work, it has to have a trailing newline.
            $content .= "\n"
                if $content =~ /\n/;

            $self->_parse_text(\$content)
                if defined $content;

            $self->_send_event('EndTableCell');
        }

        $self->_send_event('EndTableRow');
    }

    $self->_send_event($end);
}

# A table cell's contents can be a single line _not_ terminated by a
# newline. If that's the case, it won't match as a paragraph.
sub _match_table_cell {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                (
                                  ^
                                  \p{SpaceSeparator}*
                                  \S
                                  .*
                                )
                              /xmgc;

    $self->_debug_parse_result(
        $1,
        'table cell',
    ) if $self->debug();

    $self->_span_parser()->parse_block($1);
}

__PACKAGE__->meta()->make_immutable();

1;
