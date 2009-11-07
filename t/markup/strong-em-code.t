use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
Some %*em text*%
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'Some %',
            }, {
                type => 'emphasis',
            },
            [
                {
                    type => 'text',
                    text => 'em text',
                },
            ], {
                type => 'text',
                text => "%\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'emphasis markup surrounded by brackets' );
}

{
    my $text = <<'EOF';
This is ``code ` with backtick``
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => 'This is ',
            }, {
                type => 'code',
            },
            [
                {
                    type => 'text',
                    text => 'code ` with backtick',
                },
            ], {
                type => 'text',
                text => "\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'code marked with `` containing a single backtick' );
}
