use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use Test::Text::Markdown::Eventual;

# {
#     my $text = <<'EOF';
# Header 1
# ========

# Header 2
# --------

# # Header 1A

# ## Header 2A

# ### Header 3

# #### Header 4

# ##### Header 5

# ###### Header 6
# EOF

#     my $expect = [
#         {
#             'Header' => {
#                 'level'            => 1,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 1' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 2,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 2' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 1,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 1A' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 2,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 2A' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 3,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 3' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 4,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 4' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 5,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 5' } ]
#             }
#         },
#         { 'EmptyLine' => "\n" },
#         {
#             'Header' => {
#                 'level'            => 6,
#                 'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 6' } ]
#             }
#         }
#     ];

#     parse_ok( $text, $expect, 'all possible header types' );
# }

{
    my $text = <<'EOF';
Header *with em*
================
EOF

    my $expect = [
        {
            'Header' => {
                'level'            => 1,
                'NonBlockLineOnly' => [ { 'TextLineOnly' => 'Header 1' } ]
            }
        },
    ];

    parse_ok( $text, $expect, 'two-line header with em markup' );
}
