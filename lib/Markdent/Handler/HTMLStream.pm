package Markdent::Handler::HTMLStream;

use strict;
use warnings;

our $VERSION = '0.01';

use HTML::Stream;
use MooseX::Params::Validate qw( validated_list validated_hash );
use Markdent::Types qw( Bool Str OutputStream HeaderLevel );

use namespace::autoclean;
use Moose;
use MooseX::SemiAffordanceAccessor;

with 'Markdent::Role::EventsAsMethods';

has title => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has output => (
    is       => 'ro',
    isa      => OutputStream,
    required => 1,
);

has stream => (
    is      => 'ro',
    isa     => 'HTML::Stream',
    lazy    => 1,
    default => sub { HTML::Stream->new( $_[0]->output() ) },
);

my $Doctype = <<'EOF';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
          "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
EOF

sub start_document {
    my $self = shift;

    $self->output()->print($Doctype);
    $self->stream()->tag('html');
    $self->stream()->tag('head');
    $self->stream()->tag('title');
    $self->stream()->text( $self->title() );
    $self->stream()->tag('_title');
    $self->stream()->tag('_head');
    $self->stream()->tag('body');
}

sub end_document {
    my $self = shift;

    $self->stream()->tag('_body');
    $self->stream()->tag('_html');
}

sub start_header {
    my $self  = shift;
    my ($level) = validated_list( \@_,
                                  level => { isa => HeaderLevel },
                                );

    my $tag = 'h' . $level;

    $self->stream()->tag($tag);
}

sub end_header {
    my $self  = shift;
    my ($level) = validated_list( \@_,
                                  level => { isa => HeaderLevel },
                                );

    my $tag = '_h' . $level;

    $self->stream()->tag($tag);
}

sub start_blockquote {
    my $self  = shift;

    $self->stream()->tag('blockquote');
}

sub end_blockquote {
    my $self  = shift;

    $self->stream()->tag('_blockquote');
}

sub start_unordered_list {
    my $self  = shift;

    $self->stream()->tag('ul');
}

sub end_unordered_list {
    my $self  = shift;

    $self->stream()->tag('_ul');
}

sub start_ordered_list {
    my $self  = shift;

    $self->stream()->tag('ol');
}

sub end_ordered_list {
    my $self  = shift;

    $self->stream()->tag('_ol');
}

sub start_list_item {
    my $self  = shift;

    $self->stream()->tag('li');
}

sub end_list_item {
    my $self  = shift;

    $self->stream()->tag('_li');
}

sub preformatted {
    my $self = shift;
    my ($text) = validated_list( \@_, content => { isa => Str }, );

    $self->stream()->tag('pre');
    $self->stream()->tag('code');
    $self->stream()->text($text);
    $self->stream()->tag('_code');
    $self->stream()->tag('_pre');
}

sub start_paragraph {
    my $self  = shift;

    $self->stream()->tag('p');
}

sub end_paragraph {
    my $self  = shift;

    $self->stream()->tag('_p');
}

sub start_emphasis {
    my $self = shift;

    $self->stream()->tag('em');
}

sub end_emphasis {
    my $self = shift;

    $self->stream()->tag('_em');
}

sub start_strong {
    my $self = shift;

    $self->stream()->tag('strong');
}

sub end_strong {
    my $self = shift;

    $self->stream()->tag('_strong');
}

sub start_code {
    my $self = shift;

    $self->stream()->tag('code');
}

sub end_code {
    my $self = shift;

    $self->stream()->tag('_code');
}

sub auto_link {
    my $self = shift;
    my ($uri)    = validated_list(
        \@_,
        uri => { isa => Str, optional => 1 },
    );

    $self->stream()->tag( 'a', href => $uri );
    $self->stream()->text($uri);
    $self->stream()->tag('_a');
}

sub start_link {
    my $self = shift;
    my %p    = validated_hash(
        \@_,
        uri         => { isa => Str },
        title       => { isa => Str,  optional => 1 },
        id          => { isa => Str,  optional => 1 },
        implicit_id => { isa => Bool, optional => 1 },
    );

    delete @p{ grep { ! defined $p{$_} } keys %p };

    $self->stream()->tag(
        'a', href => $p{uri},
        exists $p{title} ? ( title => $p{title} ) : (),
    );
}

sub end_link {
    my $self = shift;

    $self->stream()->tag('_a');
}

sub text {
    my $self = shift;
    my ($text) = validated_list( \@_, content => { isa => Str }, );

    $self->stream()->text($text);
}

sub html {
    my $self = shift;
    my ($html) = validated_list( \@_, content => { isa => Str }, );

    $self->output()->print($html);
}

sub html_block {
    my $self = shift;
    my ($html) = validated_list( \@_, content => { isa => Str }, );

    $self->output()->print($html);
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

    delete @p{ grep { ! defined $p{$_} } keys %p };

    $self->stream()->tag(
        'img', src => $p{uri},
        ( exists $p{alt_text} ? ( alt   => $p{alt_text} ) : () ),
        ( exists $p{title}    ? ( title => $p{title} )    : () ),
    );
}

sub hr {
    my $self = shift;

    $self->stream()->tag('hr');
}

__PACKAGE__->meta()->make_immutable();

1;
