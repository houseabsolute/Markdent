package Markdent::Simple::Fragment;

use strict;
use warnings;
use namespace::autoclean;

use Markdent::Handler::HTMLStream::Fragment;
use Markdent::Parser;
use Markdent::Types qw( ArrayRef Str );
use MooseX::Params::Validate qw( validated_list );

use Moose;
use MooseX::StrictConstructor;

sub markdown_to_html {
    my $self = shift;
    my ( $dialects, $markdown ) = validated_list(
        \@_,
        dialects => {
            isa => Str | ( ArrayRef [Str] ), default => [],
        },
        markdown => { isa => Str },
    );

    my $capture = q{};
    open my $fh, '>', \$capture
        or die $!;

    my $handler
        = Markdent::Handler::HTMLStream::Fragment->new( output => $fh );

    my $parser
        = Markdent::Parser->new( dialects => $dialects, handler => $handler );

    $parser->parse( markdown => $markdown );

    return $capture;
}

1;

# ABSTRACT: Convert Markdown to an HTML Fragment

__END__

=pod

=head1 SYNOPSIS

    use Markdent::Simple::Fragment;

    my $mds  = Markdent::Simple::Fragment->new();
    my $html = $mss->markdown_to_html(
        markdown => $markdown,
    );

=head1 DESCRIPTION

This class provides a very simple interface for converting Markdown to an HTML fragment.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Simple::Fragment->new()

Creates a new Markdent::Simple::Fragment object.

=head2 $mds->markdown_to_html( markdown => $markdown )

This method turns Markdown into HTML.

You can also provide an optional "dialect" parameter.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
