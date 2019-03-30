package Markdent::Event::LineBreak;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.35';

use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event' => { event_class => __PACKAGE__ };

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: An event for a line break

__END__

=pod

=head1 DESCRIPTION

This class represents a line break

=head1 ROLES

This class does the L<Markdent::Role::Event> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
