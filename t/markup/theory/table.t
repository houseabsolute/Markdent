use strict;
use warnings;

use Test::More tests => 16;

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
+=====+=====+
| b1  | b2  |
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
        'simple table with header and two body rows, header uses +===+'
    );
}

{
    my $text = <<'EOF';
+-----+-----+
| th1 | th2 |
+-----+-----+
| b1  | b2  |
| b3  | b4  |
+-----+-----+
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
        'simple MySQL-style table (header marker at start and end of table)'
    );
}

{
    my $text = <<'EOF';
| b1  | b2  |
| b3  | b4  |
EOF

    my $expect = [
        {
            type    => 'table',
        },
        [
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
        'simple table with no header'
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
                        { type => 'paragraph' },
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

{
    my $text = <<'EOF';
| th1         | th2 |
+-------------+-----+
| * list           ||
: * l2             ::
: * l3             ::
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
                        colspan        => 2,
                        is_header_cell => 0,
                    },
                    [
                        { type => 'unordered_list' },
                        [
                            { type => 'list_item' },
                            [
                                {
                                    type => 'text',
                                    text => "list\n",
                                }
                            ],
                            { type => 'list_item' },
                            [
                                {
                                    type => 'text',
                                    text => "l2\n",
                                }
                            ],
                            { type => 'list_item' },
                            [
                                {
                                    type => 'text',
                                    text => "l3\n",
                                }
                            ],
                        ],
                    ],
                ],
            ],
        ],
    ];

    parse_ok(
        { dialect => 'Theory' },
        $text,
        $expect,
        'table with a list inside a cell'
    );
}

{
    my $text = <<'EOF';
  [Table caption]
|     | th2 |
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
                    }, {
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
                        is_header_cell => 1,
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
                        is_header_cell => 1,
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
        'simple table with empty first header cell, so first col is header cells'
    );
}

{
    my $text = <<'EOF';
| Header 1 and 2     || Nothing  |
+--------------------++----------+
| Header 1 | Header 2 | Header 3 |
+----------+----------+----------+
| B1       | B2       | B3       |
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
                            text => 'Header 1 and 2',
                        }
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 1,
                    },
                    [
                        {
                            type => 'text',
                            text => 'Nothing',
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
                            text => 'Header 1',
                        }
                    ], {
                        type           => 'table_cell',
                        alignment      => 'left',
                        colspan        => 1,
                        is_header_cell => 1,
                    },
                    [
                        {
                            type => 'text',
                            text => 'Header 2',
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
                            text => 'Header 3',
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
                            text => 'B1',
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
                            text => 'B2',
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
                            text => 'B3',
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
        'first header row should have 3 columns'
    );
}
