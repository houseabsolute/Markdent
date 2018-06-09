package Markdent::CheckedOutput;

use strict;
use warnings;

our $VERSION = '0.32';

sub new {
    my $class  = shift;
    my $output = shift;

    return bless \$output, $class;
}

## no critic (Subroutines::ProhibitBuiltinHomonyms)
sub print {
    my $self = shift;

    # We don't need warnings from IO::* about printing to closed handles when
    # we'll die in that case anyway.
    #
    ## no critic (TestingAndDebugging::ProhibitNoWarnings)
    no warnings 'io';
    ## use critic
    print { ${$self} } @_ or die "Cannot write to handle: $!";
}
## use critic

1;

# ABSTRACT: This class has no user-facing parts

__END__
