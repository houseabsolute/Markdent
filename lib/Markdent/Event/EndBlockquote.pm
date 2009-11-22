package Markdent::Event::EndBlockquote;

use strict;
use warnings;

our $VERSION = '0.01';

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

with 'Markdent::Role::Event';

__PACKAGE__->meta()->make_immutable();

1;

__END__
