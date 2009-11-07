use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';

---

EOF

    my $expect = [
        {
            type => 'hr',
        },
    ];

    parse_ok( $text, $expect, 'hr preceded by blank line' );
}


{
    my $text = <<'EOF';
---
EOF

    my $expect = [
        {
            type => 'hr',
        },
    ];

    parse_ok( $text, $expect, 'hr at beginning of document' );
}

{
    my $text = <<'EOF';

* *   ***

EOF

    my $expect = [
        {
            type => 'hr',
        },
    ];

    parse_ok( $text, $expect, 'hr preceded by blank line' );
}


{
    my $text = <<'EOF';
************************
EOF

    my $expect = [
        {
            type => 'hr',
        },
    ];

    parse_ok( $text, $expect, 'hr at beginning of document' );
}

{
    my $text = <<'EOF';
not an hr
* * * * * * *
just some text
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "not an hr\n* * * * * * *\njust some text\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'something that could be an hr but is not' );
}
