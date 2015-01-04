use strict;
use warnings;

use Test::More;

use lib 't/lib';
use lib 't/commonmark-data';

use Test::Markdent qw( html_fragment_ok );
require 'tests.pl';

my $x = 1;
for my $test ( sort { $a->{markdown} cmp $b->{markdown} } @{ _tests() } ) {
    html_fragment_ok(
        $test->{markdown},
        $test->{html},
        'commonmark ' . $x++,
        'skip validation'
    );
}

done_testing();
