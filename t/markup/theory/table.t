use strict;
use warnings;

use Test::More 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
  [Table caption]
| th1 | th2 |
+-----+-----+
| b1  | b2  |
| b3  | b4  |
EOF

    my $expect = [
        {
            type    => 'table',
            caption => 'Table caption',
        },
        [
            {
                type => 'table_header',
            },
            [
                { type => 'table_row' },
                [
                    {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 1,
                    },
                    [
                        {
                            type => 'text',
                            text => 'th1',
                        },
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 1,
                    },
                    [
                        {
                            type => 'text',
                            text => 'th2',
                        },
                    ],
                ],
            ],
            { type => 'table_body' },
            [
                { type => 'table_row' },
                [
                    {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 0,
                    },
                    [
                        {
                            type => 'text',
                            text => 'b1',
                        },
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 0,
                    },
                    [
                        {
                            type => 'text',
                            text => 'b2',
                        },
                    ],
                ],
                { type => 'table_row' },
                [
                    {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 0,
                    },
                    [
                        {
                            type => 'text',
                            text => 'b3',
                        },
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 0,
                    },
                    [
                        {
                            type => 'text',
                            text => 'b4',
                        },
                    ],
                ],
            ],
        ],
    ];

    parse_ok(
        { dialect => 'Theory' },
        $text,
        $expect,
        'simple table with header and two body rows'
    );
}
