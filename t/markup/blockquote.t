use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
> blockquote
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'blockquote',
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'one-line blockquote' );
}

{
    my $text = <<'EOF';
> blockquote
> and more
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'blockquote and more',
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'two-line blockquote, one para' );
}

{
    my $text = <<'EOF';
> blockquote
>> level 2
> level 1
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'blockquote',
                }
            ],
            { type => 'blockquote' },
            [
                {
                    type => 'paragraph',
                },
                [
                    {
                        type => 'text',
                        text => 'level 2',
                    }
                ],
            ],
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'level 1',
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'three-line blockquote, middle line is 2nd level' );
}

{
    my $text = <<'EOF';
> blockquote
>> level 2

plain text
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'blockquote',
                }
            ],
            { type => 'blockquote' },
            [
                {
                    type => 'paragraph',
                },
                [
                    {
                        type => 'text',
                        text => 'level 2',
                    }
                ],
            ],
        ], {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => 'plain text',
            },
        ],
    ];

    parse_ok( $text, $expect, 'two-line blockquote, ends at 2nd level, followed by plain paragraph' );
}

{
    my $text = <<'EOF';
> ## bq header
> normal bq
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            {
                type => 'header',
             level => 2,
            },
            [
                {
                    type => 'text',
                    text => 'bq header',
                }
            ],
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'normal bq',
                }
            ],
        ],
    ];

    parse_ok( $text, $expect, 'two-line blockquote, first line has an atx-style header' );
}

{
    my $text = <<'EOF';
> blockquote
>> level 2

plain text
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            {
                type => 'paragraph',
            },
            [
                {
                    type => 'text',
                    text => 'blockquote',
                }
            ],
            { type => 'blockquote' },
            [
                {
                    type => 'paragraph',
                },
                [
                    {
                        type => 'text',
                        text => 'level 2',
                    }
                ],
            ],
        ], {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => 'plain text',
            },
        ],
    ];

    parse_ok( $text, $expect, 'two-line blockquote, ends at 2nd level, followed by plain paragraph' );
}

{
    my $text = <<'EOF';
> bq with **some** markup *spanning
> lines*
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            { type => 'paragraph' },
            [
                {
                    type => 'text',
                    text => 'bq with ',
                }, {
                    type => 'strong',
                },
                [
                    {
                        type => 'text',
                        text => 'some',
                    }
                ], {
                    type => 'text',
                    text => ' markup ',
                }, {
                    type => 'emphasis',
                },
                [
                    {
                        type => 'text',
                        text => 'spanning lines',
                    }
                ],
            ],
        ],
    ];

    parse_ok( $text, $expect, 'two-line blockquote with markup spanning lines' );
}

{
    my $text = <<'EOF';
> bq with
  an >-less line
> and a proper line
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            { type => 'paragraph' },
            [
                {
                    type => 'text',
                    text => 'bq with   an >-less line and a proper line',
                },
            ],
        ],
    ];

    parse_ok( $text, $expect, 'three-line blockquote but middle line has no leading >' );
}

{
    my $text = <<'EOF';
> bq with
  an >-less line

> new para
EOF

    my $expect = [
        {
            type => 'blockquote',
        },
        [
            { type => 'paragraph' },
            [
                {
                    type => 'text',
                    text => 'bq with   an >-less line',
                },
            ],
            { type => 'paragraph' },
            [
                {
                    type => 'text',
                    text => 'new para',
                },
            ],
        ],
    ];

    parse_ok( $text, $expect, 'three-line blockquote but there is a paragraph break after >-less line' );
}
