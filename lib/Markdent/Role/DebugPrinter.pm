package Markdent::Role::DebugPrinter;

use strict;
use warnings;

use Markdent::Types qw( Bool );

use Moose::Role;

has debug => (
    is      => 'ro',
    isa     => Bool,
    default => $ENV{MARKDENT_DEBUG} || 0,
);

my $HR1 = q{=} x 70;
my $HR2 = q{-} x 70;

sub _debug_parse_result {
    my $self  = shift;
    my $text  = shift;
    my $type  = shift;
    my $extra = shift || [];

    my $text = '[' . $text . ']';

    my $msg = $text . "\n" . $HR2 . "\n" . '  - ' . $type . "\n";
    while ( @{$extra} ) {
        my ( $key, $value ) = splice @{$extra}, 0, 2;
        $msg .= sprintf( '    - %-10s : %s', $key, $value );
        $msg .= "\n";
    }

    $self->_print_debug($msg);
}

sub _print_debug {
    warn $HR1 . "\n" . ( ref $_[0] ) . "\n" . $_[1] . "\n";
}

no Moose::Role;

1;
