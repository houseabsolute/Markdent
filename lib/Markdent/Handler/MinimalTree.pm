package Markdent::Handler::MinimalTree;

use strict;
use warnings;

our $VERSION = '0.08';

use MooseX::Params::Validate qw( validated_list validated_hash );
use Markdent::Types qw(
    HeaderLevel Str Bool HashRef
    TableCellAlignment PosInt
);
use Tree::Simple;

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;

with 'Markdent::Role::EventsAsMethods';

has tree => (
    is      => 'ro',
    isa     => 'Tree::Simple',
    default => sub {
        Tree::Simple->new( { type => 'document' }, Tree::Simple->ROOT() );
    },
    init_arg => undef,
);

has _current_node => (
    is       => 'rw',
    isa      => 'Maybe[Tree::Simple]',
    init_arg => undef,
);

sub start_document {
    my $self = shift;

    $self->_set_current_node( $self->tree() );
}

sub end_document {
    my $self = shift;

    $self->_set_current_node(undef);
}

sub start_header {
    my $self = shift;
    my ($level) = validated_list(
        \@_,
        level => { isa => HeaderLevel },
    );

    my $header = Tree::Simple->new( { type => 'header', level => $level } );
    $self->_current_node()->addChild($header);

    $self->_set_current_node($header);
}

sub end_header {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_blockquote {
    my $self = shift;

    my $bq = Tree::Simple->new( { type => 'blockquote' } );
    $self->_current_node()->addChild($bq);

    $self->_set_current_node($bq);
}

sub end_blockquote {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_unordered_list {
    my $self = shift;

    my $bq = Tree::Simple->new( { type => 'unordered_list' } );
    $self->_current_node()->addChild($bq);

    $self->_set_current_node($bq);
}

sub end_unordered_list {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_ordered_list {
    my $self = shift;

    my $bq = Tree::Simple->new( { type => 'ordered_list' } );
    $self->_current_node()->addChild($bq);

    $self->_set_current_node($bq);
}

sub end_ordered_list {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_list_item {
    my $self = shift;

    my $para = Tree::Simple->new( { type => 'list_item' } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_list_item {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub preformatted {
    my $self = shift;
    my ($text) = validated_list( \@_, text => { isa => Str }, );

    my $pre_node
        = Tree::Simple->new( { type => 'preformatted', text => $text } );
    $self->_current_node()->addChild($pre_node);
}

sub start_paragraph {
    my $self = shift;

    my $para = Tree::Simple->new( { type => 'paragraph' } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_paragraph {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_table {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        caption => { isa => Str, optional => 1 },
    );

    my $para = Tree::Simple->new( { type => 'table', %p } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_table {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_table_header {
    my $self = shift;

    my $para = Tree::Simple->new( { type => 'table_header' } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_table_header {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_table_body {
    my $self = shift;

    my $para = Tree::Simple->new( { type => 'table_body' } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_table_body {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_table_row {
    my $self = shift;

    my $para = Tree::Simple->new( { type => 'table_row' } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_table_row {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_table_cell {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        alignment      => { isa => TableCellAlignment, optional => 1 },
        colspan        => { isa => PosInt },
        is_header_cell => { isa => Bool },
    );

    my $para = Tree::Simple->new( { type => 'table_cell', %p } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_table_cell {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_emphasis {
    my $self = shift;

    $self->_start_markup_node('emphasis');
}

sub end_emphasis {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_strong {
    my $self = shift;

    $self->_start_markup_node('strong');
}

sub end_strong {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_code {
    my $self = shift;

    $self->_start_markup_node('code');
}

sub end_code {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub auto_link {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        uri => { isa => Str, optional => 1 },
    );

    my $link_node = Tree::Simple->new( { type => 'auto_link', %p } );
    $self->_current_node()->addChild($link_node);
}

sub start_link {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        uri            => { isa => Str },
        title          => { isa => Str, optional => 1 },
        id             => { isa => Str, optional => 1 },
        is_implicit_id => { isa => Bool },
    );

    delete @p{ grep { !defined $p{$_} } keys %p };

    $self->_start_markup_node( 'link', %p );
}

sub end_link {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub text {
    my $self = shift;
    my ($text) = validated_list( \@_, text => { isa => Str }, );

    my $text_node = Tree::Simple->new( { type => 'text', text => $text } );
    $self->_current_node()->addChild($text_node);
}

sub start_html_tag {
    my $self = shift;
    my ( $tag, $attributes ) = validated_list(
        \@_,
        tag        => { isa => Str },
        attributes => { isa => HashRef },
    );

    my $tag_node = Tree::Simple->new(
        {
            type       => 'start_html_tag',
            tag        => $tag,
            attributes => $attributes,
        }
    );

    $self->_current_node()->addChild($tag_node);

    $self->_set_current_node($tag_node);
}

sub end_html_tag {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub html_comment_block {
    my $self = shift;

    my ($text) = validated_list( \@_, text => { isa => Str }, );

    my $html_node = Tree::Simple->new(
        { type => 'html_comment_block', text => $text } );
    $self->_current_node()->addChild($html_node);
}

sub html_comment {
    my $self = shift;
    my ($text) = validated_list( \@_, text => { isa => Str }, );

    my $html_node
        = Tree::Simple->new( { type => 'html_comment', text => $text } );
    $self->_current_node()->addChild($html_node);
}

sub html_tag {
    my $self = shift;
    my ( $tag, $attributes ) = validated_list(
        \@_,
        tag        => { isa => Str },
        attributes => { isa => HashRef },
    );

    my $tag_node = Tree::Simple->new(
        {
            type       => 'html_tag',
            tag        => $tag,
            attributes => $attributes,
        }
    );

    $self->_current_node()->addChild($tag_node);
}

sub html_entity {
    my $self = shift;
    my ($entity) = validated_list( \@_, entity => { isa => Str }, );

    my $html_node
        = Tree::Simple->new( { type => 'html_entity', entity => $entity } );
    $self->_current_node()->addChild($html_node);
}

sub html_block {
    my $self = shift;
    my ($html) = validated_list( \@_, html => { isa => Str }, );

    my $html_node
        = Tree::Simple->new( { type => 'html_block', html => $html } );
    $self->_current_node()->addChild($html_node);
}

sub image {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        alt_text       => { isa => Str },
        uri            => { isa => Str },
        title          => { isa => Str, optional => 1 },
        id             => { isa => Str, optional => 1 },
        is_implicit_id => { isa => Bool, optional => 1 },
    );

    my $image_node = Tree::Simple->new( { type => 'image', %p } );
    $self->_current_node()->addChild($image_node);
}

sub horizontal_rule {
    my $self = shift;

    my $hr_node = Tree::Simple->new( { type => 'horizontal_rule' } );
    $self->_current_node()->addChild($hr_node);
}

sub _start_markup_node {
    my $self = shift;
    my $type = shift;

    my $markup = Tree::Simple->new( { type => $type, @_ } );
    $self->_current_node()->addChild($markup);

    $self->_set_current_node($markup);
}

sub _set_current_up_one_level {
    my $self = shift;

    $self->_set_current_node( $self->_current_node()->getParent() );
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent::Handler::MinimalTree - A Markdent handler which builds a tree

=head1 DESCRIPTION

This class implements an event receiver which in turn builds a tree using
L<Tree::Simple>.

It is primarily intended for use in testing.

=head1 METHODS

This class provides the following methods:

=head2 Markdent::Handler::MinimalTree->new(...)

This method creates a new handler.

=head2 $mhmt->tree()

Returns the root tree for the document.

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
