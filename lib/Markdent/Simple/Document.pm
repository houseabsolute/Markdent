package Markdent::Simple::Document;

use strict;
use warnings;

use Markdent::Handler::HTMLStream::Document;
use Markdent::Parser;
use Markdent::Types qw( Str );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

sub markdown_to_html {
    my $self = shift;
    my ( $dialect, $title, $markdown ) = validated_list(
        \@_,
        dialect  => { isa => Str, default => 'Standard' },
        title    => { isa => Str },
        markdown => { isa => Str },
    );

    my $capture = q{};
    open my $fh, '>', \$capture
        or die $!;

    my $handler = Markdent::Handler::HTMLStream::Document->new(
        title  => $title,
        output => $fh,
    );

    my $parser
        = Markdent::Parser->new( dialect => $dialect, handler => $handler );

    $parser->parse( markdown => $markdown );

    return $capture;
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

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
