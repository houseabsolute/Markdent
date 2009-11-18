use strict;
use warnings;

use Test::More;

plan 'no_plan';

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
