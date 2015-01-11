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
    my @text;

    #  Code block as per GitHub standard
    #
    push @text, <<"EOF";
Some plain text.

```Perl
$code
```

More plain text.
EOF
    #  End code block


    #  Code block as per Pandoc v1.12.3.3
    #
    push @text, <<"EOF";
Some plain text.

``` {.Perl}
$code
```

More plain text.
EOF
    #  End code block


    #  Code block as per Pandoc v1.13.2
    #
    push @text, <<"EOF";
Some plain text.

``` Perl
$code
```

More plain text.
EOF
    #  End code block


    #  Code block with trailing space after Perl language declaration
    #
    push @text, <<"EOF";
Some plain text.

``` Perl 
$code
```

More plain text.
EOF
    #  End code block

    foreach my $text (@text) {

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
}

done_testing();
