use strict;
use warnings;

use Test::More;

eval { require Test::Kwalitee };
plan skip_all => "Test::Kwalitee needed for testing kwalitee"
    if $@;

Test::Kwalitee->import();
