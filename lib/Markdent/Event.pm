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
                $self->_debug_value($v);

                $dump .= q{ } x 22;
                $dump .= "|$v|\n";
            }
        }
        else {
            $dump .= sprintf( '    %-16s: %s', $key, $self->_debug_value($val) );
            $dump .= "\n";
        }
    }

    return $dump;
}

sub _debug_value {
    return defined $_[1] ? $_[1] : '<undef>';
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Event - Represents a single parse event

=head1 DESCRIPTION

An object of this class represents a single parse event. These can be either
start, end, or inline events.

=head2 Warning

This class is likely to change or become many classes in a future release

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Event->new(...)

This method creates a new event. It accepts the following parameters:

=over 4

=item * type => $type

This a string which is one of 'start', 'stop', or 'inline'.

=item * name => $name

The event name, such as 'strong', 'blockquote', or 'text'.

=item * attributes => { ... }

An arbitrary hash reference of attributes for the event.

=back

=head2 $event->event_name()

This returns a name like 'start_blockquote', 'end_strong', or 'text'.

=head2 $event->debug_dump()

Returns a string representation of the event suitable for debugging output.

=head1 AUTHOR

Dave Rolsky, E<gt>autarch@urth.orgE<lt>

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
