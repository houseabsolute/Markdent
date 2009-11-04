package Markdent::Handler::MinimalTree;

use strict;
use warnings;

our $VERSION = '0.01';

use MooseX::Params::Validate qw( validated_list validated_hash );
use Markdent::Types qw( HeaderLevel Str Bool );
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
    my $self  = shift;
    my ($level) = validated_list( \@_,
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
    my $self  = shift;

    my $bq = Tree::Simple->new( { type => 'blockquote' } );
    $self->_current_node()->addChild($bq);

    $self->_set_current_node($bq);
}

sub end_blockquote {
    my $self  = shift;

    $self->_set_current_up_one_level();
}

sub start_ordered_list {

}

sub end_ordered_list {

}

sub start_unordered_list {

}

sub end_unordered_list {

}

sub start_preformatted {
    my $self  = shift;

    my $pre = Tree::Simple->new( { type => 'preformatted' } );
    $self->_current_node()->addChild($pre);

    $self->_set_current_node($pre);
}

sub end_preformatted {
    my $self  = shift;

    $self->_set_current_up_one_level();
}

sub start_paragraph {
    my $self  = shift;

    my $para = Tree::Simple->new( { type => 'paragraph' } );
    $self->_current_node()->addChild($para);

    $self->_set_current_node($para);
}

sub end_paragraph {
    my $self  = shift;

    $self->_set_current_up_one_level();
}

sub start_emphasis {
    my $self = shift;

    $self->_start_markup_node('emphasis')
}

sub end_emphasis {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_strong {
    my $self = shift;

    $self->_start_markup_node('strong')
}

sub end_strong {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_code {
    my $self = shift;

    $self->_start_markup_node('code')
}

sub end_code {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub start_link {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        uri         => { isa => Str,  optional => 1 },
        title       => { isa => Str,  optional => 1 },
        id          => { isa => Str,  optional => 1 },
        implicit_id => { isa => Bool, optional => 1 },
    );

    die 'A link must have a uri or id'
        unless defined $p{uri} || defined $p{id};

    delete @p{ grep { ! defined $p{$_} } keys %p };

    $self->_start_markup_node( 'link', %p )
}

sub end_link {
    my $self = shift;

    $self->_set_current_up_one_level();
}

sub text {
    my $self = shift;
    my ($text) = validated_list( \@_, content => { isa => Str }, );

    my $text_node = Tree::Simple->new( { type => 'text', text => $text } );
    $self->_current_node()->addChild($text_node);
}

sub html {
    my $self = shift;
    my ($html) = validated_list( \@_, content => { isa => Str }, );

    my $html_node = Tree::Simple->new( { type => 'html', html => $html } );
    $self->_current_node()->addChild($html_node);
}

sub html_block {
    my $self = shift;
    my ($html) = validated_list( \@_, content => { isa => Str }, );

    my $html_node = Tree::Simple->new( { type => 'html_block', html => $html } );
    $self->_current_node()->addChild($html_node);
}

sub image {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        alt_text    => { isa => Str },
        uri         => { isa => Str, optional => 1 },
        title       => { isa => Str, optional => 1 },
        id          => { isa => Str, optional => 1 },
        implicit_id => { isa => Bool, optional => 1 },
    );

    my $hr_node = Tree::Simple->new( { type => 'image', %p } );
    $self->_current_node()->addChild($hr_node);
}

sub hr {
    my $self = shift;

    my $hr_node = Tree::Simple->new( { type => 'hr' } );
    $self->_current_node()->addChild($hr_node);
}

sub _start_markup_node {
    my $self = shift;
    my $type = shift;

    my $markup = Tree::Simple->new( { type => $type, @_ } );
    $self->_current_node()->addChild($markup);

    $self->_set_current_node($markup)
}

sub _set_current_up_one_level {
    my $self = shift;

    $self->_set_current_node( $self->_current_node()->getParent() );
}

__PACKAGE__->meta()->make_immutable();

1;
