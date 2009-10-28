package Text::Markdown::Eventual;

use strict;
use warnings;

use re 'eval';

our $VERSION = '0.01';

my $grammar = do {
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

    my $grammar_text = q{
<logfile: ->
<debug:on>

<[Markdown]>*

####

<token: Markdown>
  <Header>
  |
  <Blockquote>
  |
  <UnorderedListItem>
  |
  <OrderedListItem>
  |
  <Paragraph>

<token: Header>
  (?:
   <two_line_header>
   |
   ^<atx_header>$
  )
    <MATCH=(?{ $MATCH{two_line_header} ? $MATCH{two_line_header} : $MATCH{atx_header} })>

<token: two_line_header>
  ^ <text=NonBlockLineOnly> $
  ^ <level=( [-=]+ )> $
      (?{ $MATCH{level} = substr( $MATCH{level}, 0, 1 ) eq '=' ? 1 : 2 })

<token: atx_header>
    <level=(\#{1,6})>
    <text=NonBlockLineOnly>\n
      (?{ $MATCH{level} = length $MATCH{level} })

<token: Blockquote>
  ^>\s+<Header=atx_header>$
  |
  ^>\s+<MATCH=NonBlock>

<token: UnorderedListItem>
  ^[\*\-\+] <MATCH=NonBlockLineOnly>$

<token: OrderedListItem>
  ^\d+\. <MATCH=NonBlockLineOnly>$

<token: Paragraph>
  <[NonBlock]>
  \n\n+

<token: Link>
  \b
  \[ <link_text=( $nested_brackets )> \]
  (?:
    \[ <id=( [^]]+? )> \]
    |
    \( <url=( \S+ )> (?:<title=( $nested_parens )>)? \)
  )
  \b

<token: Image>
  \b
  \!
  <url=( [^]]+ )>
  (?:\[ <alt_text=( $nested_brackets )> \])?
  \b

<token: Text>
  .*?
  (?>=
    <.SpanMarkup>
    |
    \n>[ ]        # start of a blockquote
    |
    \n\n+         # end of a paragraph
    |
    \z            # end of the document
   )

<token: TextLineOnly>
  [^\n]+ (?>= \n | \z )

# repeat-no-newline
<token: NonBlock> #nl
  <SpanMarkup> #nl
  |
  <Text> #nl

<token: SpanMarkup> #nl
  <Link>
  |
  <Image>
  |
  <Strong> #nl
  |
  <Emphasis> #nl
  |
  <Code> #nl

<token: Strong> #nl
  \b\*\*<MATCH=NonBlock>(?<=\S)\*\*\b #nl
  |
  \b__<MATCH=NonBlock>(?<=\S)__\b #nl

<token: Emphasis> #nl
  \b\*<MATCH=NonBlock>(?<=\S)\*b #nl
  |
  \b_<MATCH=NonBlock>(?<=\S)_\b #nl

<token: Code> #nl
  \b`<MATCH=NonBlock>(?<=\S)`\b #nl

    };

    my ($repeated) = $grammar_text =~ /# repeat-no-newline\n(.+)/s;

    # Unfortunately, we can't just slap a (?-s:) before a named
    # rule/token. Instead, we have to repeat _everything_ just to make sure
    # that the final TextLine rule doesn't match newlines. Sigh.
    $grammar_text =~ s/(.+?) \#nl/_no_nl_variant($1)/eg;

    $repeated =~ s/ \#nl//g;
    $grammar_text .= "\n" . $repeated;

    warn $grammar_text;

    use Regexp::Grammars;
    qr{$grammar_text};
};

sub _no_nl_variant {
    my $line = shift;

    $line =~ s/<(token|rule): (.+)>/<$1 ${2}LineOnly>/g;

    $line =~ s/\.\*/(?-s:.*)/g;

    $line =~ s/<([\.\w]+)>/<${1}LineOnly>/g;

    $line =~ s/<MATCH=(\w+)>/<MATCH=${1}LineOnly>/g;

    return $line;
}

sub parse {
    my $text = shift;

    $text =~ s/\r\n?/\n/g;
    $text .= "\n"
        unless substr( $text, -1, 1 ) eq "\n";

    $text =~ $grammar;

    return $/{Markdown};
}

1;

__END__

=pod

=head1 NAME

Text::Markdown::Eventual - The fantastic new Text::Markdown::Eventual!

=head1 SYNOPSIS

XXX - change this!

    use Text::Markdown::Eventual;

    my $foo = Text::Markdown::Eventual->new();

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

=head1 COPYRIGHT & LICENSE

Copyright 2009 Dave Rolsky, All Rights Reserved.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
