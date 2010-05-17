package Markdent::Handler::HTMLStream::Document;

use strict;
use warnings;

our $VERSION = '0.10';

use Markdent::Types qw( Str );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;

with 'Markdent::Role::HTMLStream';

has title => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

my $Doctype = <<'EOF';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
EOF

sub start_document {
    my $self = shift;

    $self->_output()->print($Doctype);
    $self->_stream()->tag('html');
    $self->_stream()->tag('head');
    $self->_stream()->tag('title');
    $self->_stream()->text( $self->title() );
    $self->_stream()->tag('_title');
    $self->_stream()->tag('_head');
    $self->_stream()->tag('body');
}

sub end_document {
    my $self = shift;

    $self->_stream()->tag('_body');
    $self->_stream()->tag('_html');
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Handler::HTMLStream::Document - Turns Markdent events into a complete HTML document

=head1 DESCRIPTION

This class takes an event stream and turns it into a complete HTML document.

=head1 METHODS

This role provides the following methods:

=head2 Markdent::Handler::HTMLStream::Document->new(...)

This method creates a new handler. It accepts the following parameters:

=over 4

=item * title => $title

The title of the document. This is required.

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

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
