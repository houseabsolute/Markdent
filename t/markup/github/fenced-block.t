use strict;
use warnings;

use Test::More 0.88;

use lib 't/lib';

use Test::Markdent;

{
    my $code = 'now in a code block
    preserve the formatting';

    my $text = <<"EOF";
Some plain text.

```
$code
```

More plain text.
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "Some plain text.\n",
            },
        ], {
            type     => 'code_block',
            code     => $code,
            language => undef,
        },
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "More plain text.\n",
            },
        ],
    ];

    parse_ok(
        { dialects => 'GitHub' },
        $text,
        $expect,
        'fenced code block with no language'
    );
}

{
    my $code = 'now in a code block
    preserve the formatting';

    my $text = <<"EOF";
Some plain text.

```Perl
$code
```

More plain text.
EOF

    my $expect = [
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "Some plain text.\n",
            },
        ], {
            type     => 'code_block',
            code     => $code,
            language => 'Perl',
        },
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "More plain text.\n",
            },
        ],
    ];

    parse_ok(
        { dialects => 'GitHub' },
        $text,
        $expect,
        'fenced code block with language indicator'
    );
}

done_testing();
