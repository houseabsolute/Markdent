package Markdent::Role::DebugPrinter;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.37';

use Markdent::Types;

use Moose::Role;

has debug => (
    is      => 'rw',
    isa     => t('Bool'),
    default => $ENV{MARKDENT_DEBUG} || 0,
);

my $HR1 = q{=} x 70;
my $HR2 = q{-} x 70;

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _debug_parse_result {
    my $self  = shift;
    my $text  = shift;
    my $type  = shift;
    my $extra = shift || [];

    my $msg = '[' . $text . "]\n" . $HR2 . "\n" . '  - ' . $type . "\n";
    while ( @{$extra} ) {
        my ( $key, $value ) = splice @{$extra}, 0, 2;
        $msg .= sprintf( '    - %-10s : %s', $key, $value );
        $msg .= "\n";
    }

    $self->_print_debug($msg);
}
## use critic

sub _print_debug {
    warn $HR1 . "\n" . ( ref $_[0] ) . "\n" . $_[1] . "\n";
}

1;

# ABSTRACT: A role for classes which output debugging information

__END__

=pod

=head1 DESCRIPTION

This role implements behavior shared by all classes which output debugging information.

=head1 ATTRIBUTES

This roles provides the following attributes:

=head2 debug

This is a read-write boolean attribute.

It defaults to the value of C<$ENV{MARKDENT_DEBUG}>, if set, or 0.

=head1 METHODS

This roles provides the following methods:

=head2 $object->_debug_parse_result( $text, $type, $extra )

This method takes a text string, a parse result string (like "preformatted" or
"code_start"), and an optional array reference of extra key/value pairs.

All of this will be concatenated together in a pretty(-ish) way and passed to
C<< $object->_print_debug() >>.

=head2 $object->_print_debug($text)

This warns out the provided text along with a delimiter above the message.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
