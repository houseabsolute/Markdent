use strict;
use warnings;

use Test::Fatal;
use Test::More 0.88;

use Markdent::Dialect::Theory::BlockParser;
use Markdent::Handler::HTMLStream::Fragment;
use Markdent::Simple::Fragment;
use Markdent::Parser;
use Encode qw/encode/;

use lib 't/lib';

use utf8;

my $parser = Markdent::Simple::Fragment->new( );

my $md_unicode = <<END;
# привет

<h2>Водка медведь балалайка</h2>
END


{
    no utf8;
    my $utf8 = encode('UTF_8', $md_unicode );
    my $html = $parser->markdown_to_html( markdown => $utf8 );

    like $html, qr/привет/, 'we can use utf8'; # this fails, and chars are decoded into entities with HTML::Stream
    diag $html;
}

{
    my $html = $parser->markdown_to_html( markdown => $md_unicode );
    # this fails because of sha1_hex - it can work only with bytes
    ok $html, 'We can use unicode';
    diag $html;
}

done_testing();
