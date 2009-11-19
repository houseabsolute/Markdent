use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Markdent;

{
    my $text = <<'EOF';
Some random <span class="foo">html in</span> my text!
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => 'Some random ',
            }, {
                type => 'html',
                html => q{<span class="foo">},
            }, {
                type => 'text',
                text => 'html in',
            }, {
                type => 'html',
                html => q{</span>},
            }, {
                type => 'text',
                text => " my text!\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'html in a block' );
}

{
    my $text = <<'EOF';
Using entities: &amp; and &#38;
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => 'Using entities: ',
            }, {
                type   => 'html_entity',
                entity => 'amp',
            }, {
                type => 'text',
                text => ' and ',
            }, {
                type => 'html_entity',
                entity => '#38',
            }, {
                type => 'text',
                text => "\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'html entities in a paragraph' );
}

{
    my $html = <<'EOF';
<div>
  <p>
    An arbitrary chunk of html.
  </p>
</div>
EOF

    my $text = <<"EOF";
Some text

$html
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => "Some text\n",
            },
        ], {
            type => 'html_block',
            html => $html,
        },
    ];

    parse_ok( $text, $expect, 'html in a block' );
}

{
    my $html = <<'EOF';
<div class="foo">
  <p>
    An arbitrary chunk of html.
  </p>
</div>
EOF

    my $text = <<"EOF";
Some text

$html
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => "Some text\n",
            },
        ], {
            type => 'html_block',
            html => $html,
        },
    ];

    parse_ok( $text, $expect, 'html in a block' );
}

{
    my $html = <<'EOF';
<div>
<div>
  <p>
    An arbitrary chunk of html.
  </p>
</div>
</div>
EOF

    my $text = <<"EOF";
Some text

$html
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                type => 'text',
                text => "Some text\n",
            },
        ], {
            type => 'html_block',
            html => $html,
        },
    ];

    parse_ok( $text, $expect, 'html in a block with nested <div> tags' );
}

{
    my $html = <<'EOF';
<div>
  <div>
  <p>
    An arbitrary chunk of html.
  </p>
  </div>
</div>
EOF

    my $text = $html;

    my $expect = [
        {
            type => 'html_block',
            html => $html,
        },
    ];

    parse_ok( $text, $expect, 'html as sole content' );
}

{
    my $html = <<'EOF';
<div>
An arbitrary chunk of html.
</div>
EOF

    my $text = <<"EOF";
Some text
$html
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                'text' => "Some text\n",
                'type' => 'text'
            }, {
                'html' => '<div>',
                'type' => 'html'
            }, {
                'text' => "\nAn arbitrary chunk of html.\n",
                'type' => 'text'
            }, {
                'html' => '</div>',
                'type' => 'html'
            }, {
                type => 'text',
                text => "\n",
            },
        ]
    ];

    parse_ok( $text, $expect, 'html without preceding newline' );
}

{
    my $html = <<'EOF';
<div>
An arbitrary chunk of html.
</div>
EOF

    chomp $html;

    my $text = <<"EOF";
$html
Some text
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            {
                'html' => '<div>',
                'type' => 'html'
            }, {
                'text' => "\nAn arbitrary chunk of html.\n",
                'type' => 'text'
            }, {
                'html' => '</div>',
                'type' => 'html'
            }, {
                'text' => "\nSome text\n",
                'type' => 'text'
            },
        ]
    ];

    parse_ok( $text, $expect, 'html without following newline' );
}

{
    my $html = <<'EOF';
<div>
An arbitrary chunk of html.
</div>
EOF

    my $text = <<"EOF";
$html

$html
EOF

    my $expect = [
        {
            type => 'html_block',
            html => $html,
        },
        {
            type => 'html_block',
            html => $html,
        },
    ];

    parse_ok( $text, $expect, 'same html block twice in a row' );
}

{
    my $html = "<div>An arbitrary chunk of html.</div>\n";

    my $text = <<"EOF";
$html
A paragraph in the middle

$html
EOF

    my $expect = [
        {
            type => 'html_block',
            html => $html,
        },
        { type => 'paragraph' },
        [
            {
                type => 'text',
                text => "A paragraph in the middle\n",
            },
        ], {
            type => 'html_block',
            html => $html,
        },
    ];

    parse_ok( $text, $expect, 'two html blocks and a paragraph in the middle' );
}

{
    my $text = <<'EOF';
`Inside code we do not match <em>html</em> &amp; entities`
EOF

    my $expect = [
        {
            type => 'paragraph',
        },
        [
            { type => 'code' },
            [
                {
                    type => 'text',
                    text => "Inside code we do not match <em>html</em> &amp; entities",
                },
            ], {
                type => 'text',
                text => "\n",
            },
        ],
    ];

    parse_ok( $text, $expect, 'html inside code block is not treated as html' );
}
