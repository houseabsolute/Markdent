use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
An image: ![My Alt](http://www.example.com/example.jpg)
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'An image: ',
            }, {
                type     => 'image',
                uri      => 'http://www.example.com/example.jpg',
                alt_text => 'My Alt',
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'text and an inline link image');
}

{
    my $text = <<'EOF';
![My Alt](http://www.example.com/example.jpg "A title")
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type     => 'image',
                uri      => 'http://www.example.com/example.jpg',
                alt_text => 'My Alt',
                title    => 'A title',
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'inline image (has title)' );
}

{
    my $text = <<'EOF';
![My Alt][image]
EOF


    my $expect = [
        { type => 'paragraph' },
        [
            {
                type     => 'image',
                id       => 'image',
                alt_text => 'My Alt',
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'image linked by id' );
}

{
    my $text = <<'EOF';
![My Alt] [image]
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type     => 'image',
                id       => 'image',
                alt_text => 'My Alt',
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'image by id, space before id' );
}

{
    my $text = <<'EOF';
![My Alt][]
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type        => 'image',
                id          => 'My Alt',
                implicit_id => 1,
                alt_text    => 'My Alt',
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'image by id, implicit id' );
}

{
    my $text = <<'EOF';
![My Alt]
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type        => 'image',
                id          => 'My Alt',
                implicit_id => 1,
                alt_text    => 'My Alt',
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'image by id, implicit id (no [])' );
}
