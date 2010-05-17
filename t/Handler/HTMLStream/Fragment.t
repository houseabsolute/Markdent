use strict;
use warnings;

use Test::More;

use lib 't/lib';

use Test::Markdent;

{
    my $markdown = <<'EOF';
This is a paragraph
EOF

    my $expect_html = <<'EOF';
<p>
  This is a paragraph
</p>
EOF

    html_output_ok( $markdown, $expect_html, 'single paragraph' );
}

{
    my $markdown = <<'EOF';
Here is a [link](http://example.com) and *em* and **strong**.

* Now a list
* List 2
    * indented

Need a para to separate lists.

1. #1
2. #2
EOF

    my $expect_html = <<'EOF';
<p>
  Here is a <a href="http://example.com">link</a>
  and <em>em</em> and <strong>strong</strong>.
</p>

<ul>
  <li>Now a list</li>
  <li>List 2
    <ul>
      <li>indented</li>
    </ul>
  </li>
</ul>

<p>
  Need a para to separate lists.
</p>

<ol>
  <li>#1</li>
  <li>#2</li>
</ol>
EOF

    html_output_ok( $markdown, $expect_html, 'links, em, strong, and lists' );
}

{
    my $markdown = <<'EOF';
A Theory-style table

  [Table caption]
| Header 1 and 2     || Nothing  |
+--------------------++----------+
| Header 1 | Header 2 | Header 3 |
+----------+----------+----------+
| B1       | B2       | B3       |
|    right |  center  |          |

| l1       | x        | x        |
: l2       :          :          :
: l3       :          :          :
| end                          |||
EOF

    my $expect_html = <<'EOF';
<p>
  A Theory-style table
</p>

<table>
  <caption>Table caption</caption>
  <thead>
    <tr>
      <th align="left" colspan="2">Header 1 and 2</th>
      <th align="left">Nothing</th>
    </tr>
    <tr>
      <th align="left">Header 1
      <th align="left">Header 2</th>
      <th align="left">Header 3</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="left">B1</td>
      <td align="left">B2</td>
      <td align="left">B3</td>
    </tr>
    <tr>
      <td align="right">right</td>
      <td align="center">center</td>
      <td align="left"></td>
    </tr>
  </tbody>
  <tbody>
    <tr>
      <td align="left">
        <p>
          l1
          l2
          l3
        </p>
      </td>
      <td align="left">x</td>
      <td align="left">x</td>
    </tr>
    <tr>
      <td align="left" colspan="3">end</td>
    </tr>
  </tbody>
</table>
EOF

    html_output_ok(
        { dialect => 'Theory' },
        $markdown,
        $expect_html,
        'Complex Theory-style table'
    );
}

done_testing();
