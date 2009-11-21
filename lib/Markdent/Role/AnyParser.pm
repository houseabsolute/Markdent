package Markdent::Role::AnyParser;

use strict;
use warnings;

use Moose::Role;

with 'Markdent::Role::DebugPrinter';

has handler => (
    is       => 'ro',
    does     => 'Markdent::Role::Handler',
    required => 1,
);

sub _detab_text {
    my $self = shift;
    my $text = shift;

    # Ripped off from Text::Mardkown
    ${$text} =~ s{ ^
                   (.*?)
                   \t
                 }
                 { $1 . (q{ } x (4 - length($1) % 4))}xmge;

    return;
}

no Moose::Role;

1;
