package Markdent::Role::HTMLStream;

use strict;
use warnings;
use namespace::autoclean;

use HTML::Stream;
use Markdent::Types qw(
    HeaderLevel Str Bool HashRef
    TableCellAlignment PosInt
    OutputStream
);
use MooseX::Params::Validate qw( validated_list validated_hash );

use Moose::Role;

with 'Markdent::Role::EventsAsMethods';

requires qw( start_document end_document );

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

sub start_header {
    my $self = shift;
    my ($level) = validated_list(
        \@_,
        level => { isa => HeaderLevel },
    );

    my $tag = 'h' . $level;

    $self->_stream()->tag($tag);
}

sub end_header {
    my $self = shift;
    my ($level) = validated_list(
        \@_,
        level => { isa => HeaderLevel },
    );

    my $tag = '_h' . $level;

    $self->_stream()->tag($tag);
}

sub start_blockquote {
    my $self = shift;

    $self->_stream()->tag('blockquote');
}

sub end_blockquote {
    my $self = shift;

    $self->_stream()->tag('_blockquote');
}

sub start_unordered_list {
    my $self = shift;

    $self->_stream()->tag('ul');
}

sub end_unordered_list {
    my $self = shift;

    $self->_stream()->tag('_ul');
}

sub start_ordered_list {
    my $self = shift;

    $self->_stream()->tag('ol');
}

sub end_ordered_list {
    my $self = shift;

    $self->_stream()->tag('_ol');
}

sub start_list_item {
    my $self = shift;

    $self->_stream()->tag('li');
}

sub end_list_item {
    my $self = shift;

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
    my $self = shift;

    $self->_stream()->tag('p');
}

sub end_paragraph {
    my $self = shift;

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
    my $self = shift;

    $self->_stream()->tag('_thead');
}

sub start_table_body {
    my $self = shift;

    $self->_stream()->tag('tbody');
}

sub end_table_body {
    my $self = shift;

    $self->_stream()->tag('_tbody');
}

sub start_table_row {
    my $self = shift;

    $self->_stream()->tag('tr');
}

sub end_table_row {
    my $self = shift;

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
    my ($uri) = validated_list(
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

    delete @p{ grep { !defined $p{$_} } keys %p };

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

    delete @p{ grep { !defined $p{$_} } keys %p };

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

1;

# ABSTRACT: A role for handlers which generate HTML

__END__

=pod

=head1 DESCRIPTION

This role implements most of the code needed for event receivers which
generate a stream of HTML output based on those events.

=head1 REQUIRED METHODS

This role requires that consuming classes implement two methods, C<<
$handler->start_document() >> and C<< $handler->end_document() >>.

=head1 ROLES

This role does the L<Markdent::Role::EventsAsMethods> and
L<Markdent::Role::Handler> roles.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
