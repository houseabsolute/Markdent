package Markdent::Dialect::Theory::SpanParser;

use strict;
use warnings;

our $VERSION = '0.02';

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;
use MooseX::StrictConstructor;

extends 'Markdent::Dialect::Standard::SpanParser';


override _build_escapable_chars => sub {
    my $chars = super();

    return [ @{ $chars }, qw( | : ) ];
};

__PACKAGE__->meta()->make_immutable();

1;
