use strict;
use warnings;

use Test::More 0.88;

use Markdent::Simple::Document;

my $mds = Markdent::Simple::Document->new();

my $markdown = <<'EOF';
A header
========

Some *text* with **markup**
in a paragraph.

* a list
* with items

That is all
EOF

my $expect = <<'EOF';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head><title>Test</title></head><body><h1>A header
</h1><p>Some <em>text</em> with <strong>markup</strong>
in a paragraph.
</p><ul><li>a list
</li><li>with items
</li></ul><p>That is all
</p></body></html>
EOF

chomp $expect;

is(
    $mds->markdown_to_html( title => 'Test', markdown => $markdown ),
    $expect,
    'Markdent::Simple::Document returns expected HTML'
);

done_testing();
