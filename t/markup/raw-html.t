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
                text => ' my text!',
            },
        ],
    ];

    parse_ok( $text, $expect, 'html in a block' );
}

{
    my $html = <<'EOF';
<div>
  <p>
    An arbitrary chunk of html.
  </p>
</div>
EOF

    chomp $html;

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
                text => 'Some text',
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

    chomp $html;

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
                text => 'Some text',
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

    chomp $html;

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

    chomp $html;

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
                'text' => 'Some text ',
                'type' => 'text'
            }, {
                'html' => '<div>',
                'type' => 'html'
            }, {
                'text' => ' An arbitrary chunk of html. ',
                'type' => 'text'
            }, {
                'html' => '</div>',
                'type' => 'html'
            }
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
                'text' => ' An arbitrary chunk of html. ',
                'type' => 'text'
            }, {
                'html' => '</div>',
                'type' => 'html'
            }, {
                'text' => ' Some text',
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

    chomp $html;

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
