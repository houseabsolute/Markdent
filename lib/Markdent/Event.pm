package Markdent::Event;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( EventType Maybe Str HashRef );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has type => (
    is       => 'ro',
    isa      => EventType,
    required => 1,
);

has name => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has attributes => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} },
);

has event_name => (
    is       => 'ro',
    isa      => Str,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_event_name',
);

sub _build_event_name {
    my $self = shift;

    my @parts = $self->type() eq 'inline' ? () : $self->type();
    push @parts, $self->name();

    return join q{_}, @parts;
}

sub debug_dump {
    my $self = shift;

    my $dump = '  - ' . $self->event_name() . "\n";

    my $attr = $self->attributes();

    for my $key ( sort keys %{$attr} ) {
        my $val = $attr->{$key};

        if ( ref $val ) {
            $dump .= sprintf( '    %-16s: |%s|', $key, $val->[0] );
            $dump .= "\n";

            for my $v ( @{$val}[ 1 .. $#{$val} ] ) {
                $dump .= q{ } x 22;
                $dump .= "|$v|\n";
            }
        }
        else {
            $dump .= sprintf( '    %-16s: %s', $key, $val );
            $dump .= "\n";
        }
    }

    return $dump;
}

__PACKAGE__->meta()->make_immutable();

1;
