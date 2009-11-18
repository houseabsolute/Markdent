use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
Some text with [A link](http://www.example.com) and more text.
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type  => 'link',
                uri   => 'http://www.example.com',
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with an inline link' );
}

{
    my $text = <<'EOF';
Some text with [A link](<http://www.example.com>) and more text.
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type  => 'link',
                uri   => 'http://www.example.com',
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with an inline link' );
}

{
    my $text = <<'EOF';
Some text with [A link](http://www.example.com "A title") and more text.
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type  => 'link',
                uri   => 'http://www.example.com',
                title => "A title",
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with an inline link (has title)' );
}

{
    my $text = <<'EOF';
Some text with [A link][link id] and more text.

[link id]: /foo
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type => 'link',
                id   => 'link id',
                uri  => '/foo',
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link by id' );
}

{
    my $text = <<'EOF';
Some text with [A link] [link id] and more text.

[link id]: </bar>
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type => 'link',
                id   => 'link id',
                uri  => '/bar',
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link by id, space before id' );
}

{
    my $text = <<'EOF';
Some text with [A link][] and more text.

[A link]:
/foo/bar "title"
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type        => 'link',
                id          => 'A link',
                uri         => '/foo/bar',
                title       => 'title',
                implicit_id => 1,
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link by id, implicit id' );
}

{
    my $text = <<'EOF';
Some text with [A link] and more text.

[A link]: /foo
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type        => 'link',
                id          => 'A link',
                uri         => '/foo',
                implicit_id => 1,
            },
            [
                {
                    type => 'text',
                    text => 'A link',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link by id, implicit id (no [])' );
}

{
    my $text = <<'EOF';
Some text with [A link *with* markup](http://www.example.com) and more text.
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type => 'link',
                uri  => 'http://www.example.com',
            },
            [
                {
                    type => 'text',
                    text => 'A link ',
                }, {
                    type => 'emphasis',
                },
                [
                    {
                        type => 'text',
                        text => 'with',
                    },
                ], {
                    type => 'text',
                    text => ' markup',
                },
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link, link text has markup' );
}

{
    my $text = <<'EOF';
Some text with [A link [*with* markup] and brackets](http://www.example.com)
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type => 'link',
                uri  => 'http://www.example.com',
            },
            [
                {
                    type => 'text',
                    text => 'A link [',
                }, {
                    type => 'emphasis',
                },
                [
                    {
                        type => 'text',
                        text => 'with',
                    },
                ], {
                    type => 'text',
                    text => " markup] and brackets",
                },
            ], {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link, link text has markup and nested brackets' );
}

{
    my $text = <<'EOF';
Some text with [*A link*] and more text.

[*A link*]: /baz
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some text with ',
            }, {
                type        => 'link',
                id          => '*A link*',
                uri         => '/baz',
                implicit_id => 1,
            },
            [
                { type => 'emphasis' },
                [
                    {
                        type => 'text',
                        text => 'A link',
                    },
                ],
            ], {
                type => 'text',
                text => " and more text.\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with a link by id, implicit id contains markup' );
}

{
    my $text = <<'EOF';
An auto link <http://www.example.com/> and more text
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'An auto link ',
            }, {
                type => 'auto_link',
                uri  => 'http://www.example.com/',
            }, {
                type => 'text',
                text => " and more text\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text with an auto link' );
}
