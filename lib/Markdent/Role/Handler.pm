package Markdent::Role::Handler;

use namespace::autoclean;
use Moose::Role;

my @requires =
    map { ( 'start_' . $_, 'end_' . $_ ) }
    qw( document
        header
        blockquote
        ordered_list
        unordered_list
        preformatted
        paragraph
        emphasis
        strong
        code
      );

push @requires,
    qw( text
        link
        image
        hr
      );

requires @requires;

1;
