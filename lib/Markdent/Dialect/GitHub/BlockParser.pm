package Markdent::Dialect::GitHub::BlockParser;

use strict;
use warnings;
use namespace::autoclean;

use List::AllUtils qw( insert_after_string );
use Markdent::Event::CodeBlock;
use Markdent::Regexes qw( $BlockStart );

use Moose::Role;

with 'Markdent::Role::Dialect::BlockParser';

around _possible_block_matches => sub {
    my $orig = shift;
    my $self = shift;

    my @look_for = $self->$orig();
    insert_after_string 'list', 'fenced_code_block', @look_for;

    return @look_for;
};

sub _match_fenced_code_block {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ / \G
                                $BlockStart
                                ```
                                ([\w-]+)?        # optional language name
                                \n
                                (                # code block content
                                  (?:.|\n)+?
                                )
                                \n
                                ```
                                \n
                              /xmgc;

    my $lang = $1;
    my $code = $2;

    $self->_debug_parse_result(
        $code,
        'code block',
        ( $lang ? [ language => $lang ] : () ),
    ) if $self->debug();

    $self->_send_event(
        'CodeBlock',
        code => $code,
        ( defined $lang ? ( language => $lang ) : () ),
    );

    return 1;
}

1;
