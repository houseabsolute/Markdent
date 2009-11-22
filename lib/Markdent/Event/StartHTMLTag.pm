package Markdent::Event::StartHTMLTag;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str HashRef );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

has tag => (
    is       => 'ro',
    isa      => Str,
    required => 1,
);

has attributes => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} },
);

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__
