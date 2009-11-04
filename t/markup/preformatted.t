use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

# {
#     my $text = <<'EOF';
#     preformatted line
# EOF

#     my $expect = [
#         {
#             type => 'preformatted',
#         },
#         [
#             {
#                 type => 'text',
#                 text => "preformatted line\n",
#             }
#         ],
#     ];

#     parse_ok( $text, $expect, 'one-line preformatted' );
# }

# {
#     my $text = <<'EOF';
#     pre 1
#       pre 2
# EOF

#     my $expect = [
#         {
#             type => 'preformatted',
#         },
#         [
#             {
#                 type => 'text',
#                 text => "pre 1\n",
#             }, {
#                 type => 'text',
#                 text => "  pre 2\n",
#             }
#         ],
#     ];

#     parse_ok( $text, $expect, 'two pre lines, second has 2-space indentation' );
# }

{
    my $text = <<'EOF';
    pre 1


    pre 2
EOF

    my $expect = [
        {
            type => 'preformatted',
        },
        [
            {
                type => 'text',
                text => "pre 1\n",
            }, {
                type => 'text',
                text => "\n",
            }, {
                type => 'text',
                text => "\n",
            }, {
                type => 'text',
                text => "pre 2\n",
            }
        ],
    ];

    parse_ok( $text, $expect, 'preformatted text includes empty lines' );
}

{
    my $text = <<'EOF';
    pre 1


    pre 2

regular text
EOF

    my $expect = [
        {
            type => 'preformatted',
        },
        [
            {
                type => 'text',
                text => "pre 1\n",
            }, {
                type => 'text',
                text => "\n",
            }, {
                type => 'text',
                text => "\n",
            }, {
                type => 'text',
                text => "pre 2\n",
            }
        ], {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => 'regular text',
            },
        ],
    ];

    parse_ok( $text, $expect, 'preformatted text with empty lines followed by regular paragraph' );
}
