use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
**strong with *bad** em*
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            { type => 'strong' },
            [
                {
                    type => 'text',
                    text => 'strong with *bad',
                },
            ], {
                type => 'text',
                text => ' em*',
            },
        ],
    ];

    parse_ok( $text, $expect, 'valid strong containing invalid emphasis' );
}

{
    my $text = <<'EOF';
**bad strong with *good em*
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => '**bad strong with ',
            },
            { type => 'emphasis' },
            [
                {
                    type => 'text',
                    text => 'good em',
                },
            ],
        ],
    ];

    parse_ok( $text, $expect, 'bad strong start containing valid emphasis' );
}
