package Markdent::Handler::HTMLStream;

use strict;
use warnings;

our $VERSION = '0.08';

use HTML::Stream;
use Markdent::Types qw(
    HeaderLevel Str Bool HashRef
    TableCellAlignment PosInt
    OutputStream
);
use MooseX::Params::Validate qw( validated_list validated_hash );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;

with 'Markdent::Role::EventsAsMethods';

has title => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has _output => (
    is       => 'ro',
    isa      => OutputStream,
    required => 1,
    init_arg => 'output',
);

has _stream => (
    is       => 'ro',
    isa      => 'HTML::Stream',
    init_arg => undef,
    lazy     => 1,
    default  => sub { HTML::Stream->new( $_[0]->_output() ) },
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

sub start_header {
    my $self  = shift;
    my ($level) = validated_list( \@_,
                                  level => { isa => HeaderLevel },
                                );

    my $tag = 'h' . $level;

    $self->_stream()->tag($tag);
}

sub end_header {
    my $self  = shift;
    my ($level) = validated_list( \@_,
                                  level => { isa => HeaderLevel },
                                );

    my $tag = '_h' . $level;

    $self->_stream()->tag($tag);
}

sub start_blockquote {
    my $self  = shift;

    $self->_stream()->tag('blockquote');
}

sub end_blockquote {
    my $self  = shift;

    $self->_stream()->tag('_blockquote');
}

sub start_unordered_list {
    my $self  = shift;

    $self->_stream()->tag('ul');
}

sub end_unordered_list {
    my $self  = shift;

    $self->_stream()->tag('_ul');
}

sub start_ordered_list {
    my $self  = shift;

    $self->_stream()->tag('ol');
}

sub end_ordered_list {
    my $self  = shift;

    $self->_stream()->tag('_ol');
}

sub start_list_item {
    my $self  = shift;

    $self->_stream()->tag('li');
}

sub end_list_item {
    my $self  = shift;

    $self->_stream()->tag('_li');
}

sub preformatted {
    my $self = shift;
    my ($text) = validated_list( \@_, text => { isa => Str }, );

    $self->_stream()->tag('pre');
    $self->_stream()->tag('code');
    $self->_stream()->text($text);
    $self->_stream()->tag('_code');
    $self->_stream()->tag('_pre');
}

sub start_paragraph {
    my $self  = shift;

    $self->_stream()->tag('p');
}

sub end_paragraph {
    my $self  = shift;

    $self->_stream()->tag('_p');
}

sub start_table {
    my $self = shift;
    my ($caption) = validated_list(
        \@_,
        caption => { isa => Str, optional => 1 },
    );

    $self->_stream()->tag('table');

    if ( defined $caption && length $caption ) {
        $self->_stream()->tag('caption');
        $self->_stream()->text($caption);
        $self->_stream()->tag('_caption');
    }
}

sub end_table {
    my $self = shift;

    $self->_stream()->tag('_table');
}

sub start_table_header {
    my $self = shift;

    $self->_stream()->tag('thead');
}

sub end_table_header {
    my $self  = shift;

    $self->_stream()->tag('_thead');
}

sub start_table_body {
    my $self  = shift;

    $self->_stream()->tag('tbody');
}

sub end_table_body {
    my $self  = shift;

    $self->_stream()->tag('_tbody');
}

sub start_table_row {
    my $self  = shift;

    $self->_stream()->tag('tr');
}

sub end_table_row {
    my $self  = shift;

    $self->_stream()->tag('_tr');
}

sub start_table_cell {
    my $self = shift;
    my ( $alignment, $colspan, $is_header ) = validated_list(
        \@_,
        alignment      => { isa => TableCellAlignment, optional => 1 },
        colspan        => { isa => PosInt },
        is_header_cell => { isa => Bool },
    );

    my $tag = $is_header ? 'th' : 'td';

    my %attr = ( align => $alignment );
    $attr{colspan} = $colspan
        if $colspan != 1;

    $self->_stream()->tag( $tag, %attr );
}

sub end_table_cell {
    my $self = shift;
    my ($is_header) = validated_hash(
        \@_,
        is_header_cell => { isa => Bool },
    );

    $self->_stream()->tag( $is_header ? '_th' : '_td' );
}

sub start_emphasis {
    my $self = shift;

    $self->_stream()->tag('em');
}

sub end_emphasis {
    my $self = shift;

    $self->_stream()->tag('_em');
}

sub start_strong {
    my $self = shift;

    $self->_stream()->tag('strong');
}

sub end_strong {
    my $self = shift;

    $self->_stream()->tag('_strong');
}

sub start_code {
    my $self = shift;

    $self->_stream()->tag('code');
}

sub end_code {
    my $self = shift;

    $self->_stream()->tag('_code');
}

sub auto_link {
    my $self = shift;
    my ($uri)    = validated_list(
        \@_,
        uri => { isa => Str, optional => 1 },
    );

    $self->_stream()->tag( 'a', href => $uri );
    $self->_stream()->text($uri);
    $self->_stream()->tag('_a');
}

sub start_link {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        uri            => { isa => Str },
        title          => { isa => Str, optional => 1 },
        id             => { isa => Str, optional => 1 },
        is_implicit_id => { isa => Bool, optional => 1 },
    );

    delete @p{ grep { ! defined $p{$_} } keys %p };

    $self->_stream()->tag(
        'a', href => $p{uri},
        exists $p{title} ? ( title => $p{title} ) : (),
    );
}

sub end_link {
    my $self = shift;

    $self->_stream()->tag('_a');
}

sub text {
    my $self = shift;
    my ($text) = validated_list( \@_, text => { isa => Str }, );

    $self->_stream()->text($text);
}

sub start_html_tag {
    my $self = shift;
    my ( $tag, $attributes ) = validated_list(
        \@_,
        tag        => { isa => Str },
        attributes => { isa => HashRef },
    );

    $self->_stream()->tag( $tag, %{$attributes} );
}

sub html_comment_block {
    my $self = shift;
    my ($text) = validated_list(
        \@_,
        text => { isa => Str },
    );

    # HTML::Stream->comment() adds extra whitespace for no good reason.
    $self->_output()->print( '<!--' . $text . '-->' . "\n" );
}

sub html_comment {
    my $self = shift;
    my ($text) = validated_list(
        \@_,
        text => { isa => Str },
    );

    # HTML::Stream->comment() adds extra whitespace for no good reason.
    $self->_output()->print( '<!--' . $text . '-->' );
}

sub html_tag {
    my $self = shift;
    my ( $tag, $attributes ) = validated_list(
        \@_,
        tag        => { isa => Str },
        attributes => { isa => HashRef },
    );

    $self->_stream()->tag( $tag, %{$attributes} );
}

sub end_html_tag {
    my $self = shift;
    my ($tag) = validated_list(
        \@_,
        tag => { isa => Str },
    );

    $self->_stream()->tag( q{_} . $tag );
}

sub html_entity {
    my $self = shift;
    my ($entity) = validated_list( \@_, entity => { isa => Str }, );

    $self->_stream()->ent($entity);
}

sub html_block {
    my $self = shift;
    my ($html) = validated_list( \@_, html => { isa => Str }, );

    $self->_output()->print($html);
}

sub image {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        alt_text       => { isa => Str },
        uri            => { isa => Str, optional => 1 },
        title          => { isa => Str, optional => 1 },
        id             => { isa => Str, optional => 1 },
        is_implicit_id => { isa => Bool, optional => 1 },
    );

    delete @p{ grep { ! defined $p{$_} } keys %p };

    $self->_stream()->tag(
        'img', src => $p{uri},
        ( exists $p{alt_text} ? ( alt   => $p{alt_text} ) : () ),
        ( exists $p{title}    ? ( title => $p{title} )    : () ),
    );
}

sub horizontal_rule {
    my $self = shift;

    $self->_stream()->tag('hr');
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Handler::HTMLStream - A Markdent handler which generates HTML

=head1 DESCRIPTION

This class implements an event receiver which in turn generates a stream of
HTML output based on those events.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Handler::HTMLStream->new(...)

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

This class does the L<Markdent::Role::EventsAsMethods> and
L<Markdent::Role::Handler> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
