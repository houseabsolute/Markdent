package Markdent::Handler::HTMLStream::Fragment;

use strict;
use warnings;

our $VERSION = '0.10';

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;

with 'Markdent::Role::HTMLStream';

sub start_document { }
sub end_document   { }

__PACKAGE__->meta()->make_immutable();

1;

# ABSTRACT: Turns Markdent events into an HTML fragment

__END__

=pod

=head1 DESCRIPTION

This class takes an event stream and turns it into an HTML document, without a
doctype, C<< <html> >>, C<< <head> >> or C<< <body> >> tags.

=head1 METHODS

This role provides the following methods:

=head2 Markdent::Handler::HTMLStream::Document->new(...)

This method creates a new handler. It accepts the following parameters:

=over 4

=item * output => $fh

The file handle to which HTML output will be streamed. If you want to capture
the output in a string, you can open a filehandle to a string:

  my $buffer = q{};
  open my $fh, '>', \$buffer;

=back

=head1 ROLES

This class does the L<Markdent::Role::HTMLStream>,
L<Markdent::Role::EventsAsMethods>, and L<Markdent::Role::Handler> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
