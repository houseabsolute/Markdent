use strict;
use warnings;

use Test::More tests => 10;

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

{
    my $text = <<'EOF';
| th1 | th2 |
+-----+-----+
| b1  | b2  |
| b3  | b4  |
  [Table caption]
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
        'simple table with header and two body rows - caption on the bottom'
    );
}

{
    my $text = <<'EOF';
  [Table caption]
|   th1 |   th2 |
+-------+-------+
| b1 | b2 |
| b3 | b4 |
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
                        alignment      => 'right',
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
                        alignment      => 'right',
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
                        alignment      => 'right',
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
                        alignment      => 'right',
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
                        alignment      => 'right',
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
                        alignment      => 'right',
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
        'simple table with header and two body rows, all right-aligned'
    );
}

{
    my $text = <<'EOF';
  [Table caption]
| th1   | th2   |
+-------+-------+
| th1-1 | th2-1 |
+-------+-------+
| b1 | b2 |
| b3 | b4 |
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
                            text => 'th1-1',
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
                            text => 'th2-1',
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
        'simple table with two header rows and two body rows'
    );
}

{
    my $text = <<'EOF';
 th1   | th2   | th3
-------+-------+-----
 b1    | b2    | b3
 b4    | b5    | b6
EOF

    my $expect = [
        {
            type => 'table',
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
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 1,
                    },
                    [
                        {
                            type => 'text',
                            text => 'th3',
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
                    ], {
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
                            text => 'b4',
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
                            text => 'b5',
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
                            text => 'b6',
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
        'three cells across, no leading/trailing pipes or pluses'
    );
}

{
    my $text = <<'EOF';
 th1   | th2   | th3
-------+-------+-----
 b1    | b2    | b3

 b4    | b5    | b6
EOF

    my $expect = [
        {
            type => 'table',
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
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 1,
                    },
                    [
                        {
                            type => 'text',
                            text => 'th3',
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
                    ], {
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
                            text => 'b4',
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
                            text => 'b5',
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
                            text => 'b6',
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
        'three cells across, two table bodies'
    );
}

{
    my $text = <<'EOF';
 th1          || th3
-------+-------+-----
 b1    | b2         ||
 b4                |||
EOF

    my $expect = [
        {
            type => 'table',
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
                        colspan        => 2,
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
                            text => 'th3',
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
                        colspan        => 2,
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
                        colspan        => 3,
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
        'three cells across, each row has some >1 colspan cells'
    );
}


{
    my $text = <<'EOF';
 th1          || th3
-------+-------+-----
 b1    | b2         ||
 b4                |||
EOF

    my $expect = [
        {
            type => 'table',
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
                        colspan        => 2,
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
                            text => 'th3',
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
                        colspan        => 2,
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
                        colspan        => 3,
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
        'three cells across, each row has some >1 colspan cells'
    );
}

{
    my $text = <<'EOF';
| th1 | th2 |
+-----+-----+
| b\| | b2  |
| b3  | b4  |
EOF

    my $expect = [
        {
            type    => 'table',
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
                            text => 'b|',
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
        'simple table with escaped pipe in cell'
    );
}

{
    my $text = <<'EOF';
| th1         | th2 |
+-------------+-----+
| b1          | b2  |
: continues\: :     :
: here        :     :
| b3          | b4  |
EOF

    my $expect = [
        {
            type    => 'table',
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
                     {type => 'paragraph' },
                     [
                        {
                            type => 'text',
                            text => "b1\ncontinues:\nhere\n",
                        },
                      ]
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
        'simple table with continuation lines'
    );
}
