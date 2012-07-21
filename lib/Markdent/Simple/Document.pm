package Markdent::Simple::Document;

use strict;
use warnings;
use namespace::autoclean;

use Markdent::Handler::HTMLStream::Document;
use Markdent::Types qw( ArrayRef Str );
use MooseX::Params::Validate qw( validated_list );

use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Simple';

sub markdown_to_html {
    my $self = shift;
    my ( $dialects, $title, $markdown ) = validated_list(
        \@_,
        dialects => {
            isa => Str | ( ArrayRef [Str] ), default => [],
        },
        title    => { isa => Str },
        markdown => { isa => Str },
    );

    my $handler_class = 'Markdent::Handler::HTMLStream::Document';
    my %handler_p = ( title => $title );

    return $self->_parse_markdown(
        $markdown,
        $dialects,
        $handler_class,
        \%handler_p
    );
}

1;

# ABSTRACT: Convert Markdown to an HTML Document

__END__

=pod

=head1 SYNOPSIS

    use Markdent::Simple::Document;

    my $mds  = Markdent::Simple::Document->new();
    my $html = $mss->markdown_to_html(
        title    => 'My Document',
        markdown => $markdown,
    );

=head1 DESCRIPTION

This class provides a very simple interface for converting Markdown to a
complete HTML document.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Simple::Document->new()

Creates a new Markdent::Simple::Document object.

=head2 $mds->markdown_to_html( title => $title, markdown => $markdown )

This method turns Markdown into HTML. You must provide a title as well, which
will be used as the C<< <title> >> for the resulting HTML document.

You can also provide an optional "dialect" parameter.

=head1 ROLES

This class does the L<Markdent::Role::Simple> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
