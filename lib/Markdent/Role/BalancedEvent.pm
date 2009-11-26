package Markdent::Role::BalancedEvent;

use strict;
use warnings;

our $VERSION = '0.02';

use List::AllUtils qw( all );
use Markdent::Types qw( ArrayRef Str );
use MooseX::Params::Validate qw( pos_validated_list );

use namespace::autoclean;
use MooseX::Role::Parameterized;

parameter compare => (
    isa => ArrayRef[Str],
);

role {
    my $p = shift;

    my @compare = @{ $p->compare() || [] };

    method balances_event => sub {
        my $self = shift;
        my ($other) = pos_validated_list( \@_, { does => 'Markdent::Role::Event' } );

        return 0 unless $self->name() eq $other->name();

        return 0
            unless ( $self->is_start() && $other->is_end() )
            || ( $self->is_end() && $other->is_start() );

        return 1 unless @compare;

        return all { $self->$_() eq $other->$_() } @compare;

        return 0;
    };
};

1;

__END__

=pod

=head1 NAME

Markdent::Role::BalancedEvent - A parameterized role for end events which can check if the match a start event

=head1 DESCRIPTION

This role provides behavior for end events which can be checked for a matching
start event. This includes things like strong, emphasis, code, and html tag
events, all of which can be compared to a start event.

=head1 ROLE PARAMETERS

This role accepts the following parameters:

=over 4

=item * compare => [ ... ]

This should be a list of attribute names which will be compared between the
start and end events.

=back

=head1 METHODS

This role provides the following methods:

=head2 $event->balances_event($event2)

Given an event, this returns true if two events balance each other. This is
done by comparing types (StartCode matches EndCode), as well as the attributes
provided in the compare parameter.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
