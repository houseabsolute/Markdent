package Markdent;

use strict;
use warnings;

our $VERSION = '0.01';

use Markdent::Types qw( Str ArrayRef Bool );
use MooseX::Params::Validate qw( validated_list );

use namespace::autoclean;
use Moose;
use MooseX::StrictConstructor;

my $HR1 = q{=} x 70;
my $HR2 = q{-} x 70;

has handler => (
    is       => 'ro',
    does     => 'Markdent::Role::Handler',
    required => 1,
);

has debug => (
    is      => 'ro',
    isa     => Bool,
    default => $ENV{MARKDENT_DEBUG} || 0,
);

has __buffered_lines => (
    traits   => ['Array'],
    is       => 'ro',
    isa      => ArrayRef[Str],
    default  => sub { [] },
    init_arg => undef,
    handles  => {
        _push_buffer    => 'push',
        _buffered_lines => 'elements',
        _clear_buffer   => 'clear',
    },
);

has __current_spans => (
    traits   => ['Array'],
    is       => 'ro',
    isa      => ArrayRef[Str],
    default  => sub { [] },
    init_arg => undef,
    handles  => {
        _current_spans       => 'elements',
        _add_current_span    => 'push',
        _remove_current_span => 'shift',
    },
);

has _span_text_buffer => (
    traits   => ['String'],
    is       => 'ro',
    isa      => Str,
    default  => q{},
    init_arg => undef,
    handles  => {
        _save_span_text         => 'append',
        _has_span_text_buffer   => 'length',
        _clear_span_text_buffer => 'clear',
    },
);

sub parse {
    my $self = shift;
    my ( $text, $handler ) = validated_list(
        \@_,
        text => { isa => Str },
    );

    $text =~ s/\r\n?/\n/g;
    $text .= "\n"
        unless substr( $text, -1, 1 ) eq "\n";

    $self->handler()->start_document();

    for my $line ( split /\n/, $text ) {
        chomp $line;
        $self->_parse_line($line);
    }

    $self->handler()->end_document();

    return;
}

sub _parse_line {
    my $self = shift;
    my $line = shift;

    if ( $line =~ /^(\#{1,6})\s+(.+)/ ) {
        my $level       = length $1;
        my $header_text = $2;

        $self->_debug_parse_result(
            $line,
            'atx header',
            [ level => $level ],
        ) if $self->debug();

        $self->_header( $level, $header_text );
    }
    elsif ( $line =~ /^\s*$/ ) {

        # empty line
    }
    elsif ( $line =~ /^(=+|-+)$/ ) {
        my @buffer = $self->_buffered_lines();

        my $header_text = pop @buffer;

        if (@buffer) {
            $self->_paragraph(@buffer);
        }

        my $level = substr( $1, 0, 1 ) eq '=' ? 1 : 2;

        $self->_debug_parse_result(
            [ $header_text, $line ],
            'two-line header',
            [ level => $level ],
        ) if $self->debug();

        $self->_header( $level, $header_text );

        $self->_clear_buffer();
    }
    else {
        $self->_push_buffer($line);
    }
}

sub _header {
    my $self  = shift;
    my $level = shift;
    my $text  = shift;

    $self->handler()->start_header( level => $level );
    $self->_parse_span_markup($text);
    $self->handler()->end_header();
}

sub _parse_span_markup {
    my $self = shift;
    my $text = shift;

    $self->_debug_out( "Parsing text for span-level markup\n$HR2\n$text\n" )
        if $self->debug();

    # Note that we have to pass a _reference_ to text in order to make sure
    # that we are matching the same variable with /g regexes each time.
 PARSE_SPAN:
    while (1) {
        if ( $text =~ /\G\z/gc ) {
            $self->_event_for_text_buffer();
            last;
        }

        for my $span ( $self->_possible_span_matches() ) {
            my $meth = '_match_' . $span;

            if ( $self->$meth( \$text ) ) {
                next PARSE_SPAN;
            }
        }

        $self->_match_plain_text( \$text );
    }
}

sub _possible_span_matches {
    my $self = shift;

    my @look_for;

    for my $type ( qw( strong emphasis  ) ) {
        if ( $self->_current_span_includes($type) ) {
            push @look_for, $type . '_end';
        }
        else {
            push @look_for, $type . '_start';
        }
    }

    return @look_for;
    push @look_for, qw( link image );

    return @look_for;
}

sub _current_span_includes {
    my $self = shift;
    my $span = shift;

    return grep { $_ eq $span } $self->_current_spans();
}

sub _match_strong_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/(?:\*\*|__)/ )
        or return;

    $self->_markup_event('start_strong');

    $self->_add_current_span('strong');

    return 1;
}

sub _match_strong_end {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_end( $text, qr/(?:\*\*|__)/ )
        or return;

    $self->_markup_event('end_strong');

    $self->_remove_current_span();

    return 1;
}

sub _match_emphasis_start {
    my $self = shift;
    my $text = shift;

    my ($delim) = $self->_match_delimiter_start( $text, qr/(?:\*|_)/ )
        or return;

    $self->_markup_event('start_emphasis');

    $self->_add_current_span('emphasis');

    return 1;
}

sub _match_emphasis_end {
    my $self = shift;
    my $text = shift;

    $self->_match_delimiter_end( $text, qr/(?:\*|_)/ )
        or return;

    $self->_markup_event('end_emphasis');

    $self->_remove_current_span();

    return 1;
}

sub _match_delimiter_start {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    return unless ${$text} =~ /(?: ^ | [ ] \G ) ($delim) (?= \S ) /xgc;

    return $1;
}

sub _match_delimiter_end {
    my $self  = shift;
    my $text  = shift;
    my $delim = shift;

    return unless ${$text} =~ /[^\s\\] \G $delim (?= \s | \z ) /xgc;

    return 1;
}

sub _match_plain_text {
    my $self = shift;
    my $text = shift;

    # Note that we're careful not to consume any of the characters marking the
    # (possible) end of the plain text. If those things turn out to _not_ be
    # markup, we'll get them on the next pass, because we always match at
    # least one character, so we should never get stuck in a loop.
    return unless
        ${$text} =~ /\G
                     ( .+? )              # at least one character followed by ...
                     (?:
                       (?= \* | _ | \` )  #   possible span markup
                       |
                       (?= !?\[ )         #   or a possible image or link
                       |
                       \z                 #   or the end of the string
                     )
                    /xgc;

    $self->_debug_out( "Interpreting as plain text\n$HR2\n[$1]\n" );

    my $plain = $self->_unescape_plain_text($1);

    $self->_save_span_text($plain);

    return 1;
}

sub _unescape_plain_text {
    my $self  = shift;
    my $plain = shift;

    $plain =~ s/\\([\`*_{}[\]()#+-.!])/$1/g;

    return $plain;
}

sub _markup_event {
    my $self = shift;
    my $meth = shift;

    $self->_event_for_text_buffer();

    $self->_debug_out( "Found markup: $meth\n" );

    $self->handler()->$meth(@_);
}

sub _event_for_text_buffer {
    my $self = shift;

    return unless $self->_has_span_text_buffer();

    $self->handler()->text( text => $self->_span_text_buffer() );
    $self->_clear_span_text_buffer();
}

sub _debug_parse_result {
    my $self  = shift;
    my $lines = shift;
    my $type  = shift;
    my $extra = shift || [];

    my $text = join q{}, map { $_ . "\n" } ref $lines ? @{$lines} : $lines;

    my $msg = $text . $HR2 . "\n" . '  - ' . $type . "\n";
    while ( @{ $extra} ) {
        my ( $key, $value ) = splice @{$extra}, 0, 2;
        $msg .= sprintf( '    - %-10s : %s', $key, $value );
        $msg .= "\n";
    }

    $self->_debug_out($msg);
}

sub _debug_out {
    warn $HR1 . "\n" . $_[1] . "\n";
}

# These two regexes stolen from Text::Markdown
my $nested_brackets;
$nested_brackets = qr{
    (?>                                 # Atomic matching
       [^\[\]]+                         # Anything other than brackets
     |
       \[
         (??{ $nested_brackets })       # Recursive set of nested brackets
       \]
    )*
}x;

my $nested_parens;
$nested_parens = qr{
    (?>                                 # Atomic matching
       [^()\s]+                         # Anything other than parens or whitespace
     |
       \(
         (??{ $nested_parens })         # Recursive set of nested brackets
       \)
    )*
}x;


our $delim;
sub _build_span_markup_regex {
    my $self = shift;

    qr{
  \G

  (?<start_strong>
    (?<=[ ])
    (?<strong_delim>\*\*|__)
    (?=\S)
  )
  |
  (?<end_strong>
    (?<=\S)
    \k<strong_delim>
    (?= [ ] | $ )
  )
  |
  (?<start_emphasis>
    (?<=[ ])
    (?<em_delim>[\*_])
    (?=\S)
  )
  |
  (?<end_emphasis>
    (?<=\S)

    (?= [ ] | $ )
  )
  |
  (?<start_code>
    \b
    (?<code_delim>[\`]+)
    (?=\S)
  )
  |
  (?<end_code>
    (?<=\S)
    \k<code_delim>
    \b
  )
  |
  (?<link>
    \[(?<link_text>$nested_brackets)\]
    (?:
      \((?<url>$nested_parens)\)
      |
      \s*\[(?<id>[^\]]*)\]
    )
  )
  |
  (?<image>
    \!
    \[(?<alt_text>$nested_brackets)\]
    (?:
      \((?<url>\S+)
         (?:
           "(?<title>[^\"]*)"
           |
           '(?<title>[^\']*)'
         )?
      \)
      |
      \[(?<id>[^\]]*)\]
    )
  )
  |
  (?<text>
    .+?
    (?<=[ ])
    (?= \*\S )
    |
    (?= $ )
  )

    }x;
}

__PACKAGE__->meta()->make_immutable();

1;

__END__

=pod

=head1 NAME

Markdent - The fantastic new Markdent!

=head1 SYNOPSIS

XXX - change this!

    use Markdent;

    my $foo = Markdent->new();

    ...

=head1 DESCRIPTION

=head1 METHODS

This class provides the following methods

=head1 AUTHOR

Dave Rolsky, E<gt>autarch@urth.orgE<lt>

=head1 BUGS

Please report any bugs or feature requests to C<bug-text-markdown-eventual@rt.cpan.org>,
or through the web interface at L<http://rt.cpan.org>.  I will be
notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 DONATIONS

If you'd like to thank me for the work I've done on this module,
please consider making a "donation" to me via PayPal. I spend a lot of
free time creating free software, and would appreciate any support
you'd care to offer.

Please note that B<I am not suggesting that you must do this> in order
for me to continue working on this particular software. I will
continue to do so, inasmuch as I have in the past, for as long as it
interests me.

Similarly, a donation made in this way will probably not make me work
on this software much more, unless I get so many donations that I can
consider working on free software full time, which seems unlikely at
best.

To donate, log into PayPal and send money to autarch@urth.org or use
the button on this page:
L<http://www.urth.org/~autarch/fs-donation.html>

=head1 AUTHOR

Dave Rolsky, E<lt>autarch@urth.orgE<gt>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
