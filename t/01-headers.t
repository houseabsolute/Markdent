use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Text::Markdown::Eventual;

{
    my $text = <<'EOF';
Header 1
========

Header 2
--------

# Header 1A

## Header 2A

### Header 3

#### Header 4

##### Header 5

###### Header 6
EOF

    my $expect = {
        Header => [
            {
                'level' => 1,
                'text'  => 'Header 1'
            }, {
                'level' => 2,
                'text'  => 'Header 2'
            }, {
                'level' => 1,
                'text'  => 'Header 1A'
            }, {
                'level' => 2,
                'text'  => 'Header 2A'
            }, {
                'level' => 3,
                'text'  => 'Header 3'
            }, {
                'level' => 4,
                'text'  => 'Header 4'
            }, {
                'level' => 5,
                'text'  => 'Header 5'
            }, {
                'level' => 6,
                'text'  => 'Header 6'
            }
        ],
    };

    parse_ok( $text, $expect, 'all possible header types' );
}
