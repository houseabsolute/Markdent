package Markdent::Handler::MinimalTree;

use strict;
use warnings;

our $VERSION = '0.01';

use MooseX::Params::Validate qw( validated_list );
use Markdent::Types qw( HeaderLevel Str );
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

}

sub end_blockquote {

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

}

sub end_preformatted {

}

sub start_paragraph {

}

sub end_paragraph {

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

}

sub end_code {

}

sub text {
    my $self = shift;
    my ($text) = validated_list( \@_,
                                  content => { isa => Str },
                                );

    my $text_node = Tree::Simple->new( { type => 'text', text => $text } );
    $self->_current_node()->addChild($text_node);
}

sub link {

}

sub image {

}

sub hr {

}

sub _start_markup_node {
    my $self = shift;
    my $type = shift;

    my $markup = Tree::Simple->new( { type => $type } );
    $self->_current_node()->addChild($markup);

    $self->_set_current_node($markup)
}

sub _set_current_up_one_level {
    my $self = shift;

    $self->_set_current_node( $self->_current_node()->getParent() );
}

__PACKAGE__->meta()->make_immutable();

1;
