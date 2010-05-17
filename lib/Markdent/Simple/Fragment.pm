package Markdent::Simple::Fragment;

use strict;
use warnings;

our $VERSION = '0.09';

use Markdent::Handler::HTMLStream::Fragment;
use Markdent::Parser;
use Markdent::Types qw( Str );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

sub markdown_to_html {
    my $self = shift;
    my ( $dialect, $markdown ) = validated_list(
        \@_,
        dialect  => { isa => Str, default => 'Standard' },
        markdown => { isa => Str },
    );

    my $capture = q{};
    open my $fh, '>', \$capture
        or die $!;

    my $handler
        = Markdent::Handler::HTMLStream::Fragment->new( output => $fh );

    my $parser
        = Markdent::Parser->new( dialect => $dialect, handler => $handler );

    $parser->parse( markdown => $markdown );

    return $capture;
}

1;

__END__

=pod

=head1 NAME

Markdent::Simple::Fragment - Convert Markdown to an HTML Fragment

=head1 SYNOPSIS

    use Markdent::Simple::Fragment;

    my $mds  = Markdent::Simple::Fragment->new();
    my $html = $mss->markdown_to_html(
        title    => 'My Fragment',
        markdown => $markdown,
    );

=head1 DESCRIPTION

This class provides a very simple interface for converting Markdown to an HTML fragment.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Simple::Fragment->new()

Creates a new Markdent::Simple::Fragment object.

=head2 $mds->markdown_to_html( markdown => $markdown )

This method turns Markdown into HTML. You must provide a title as well, which
will be used as the C<< <title> >> for the resulting HTML document.

You can also provide an optional "dialect" parameter.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009-2010 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
