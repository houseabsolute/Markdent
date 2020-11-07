package Markdent::Dialect::GitHub::SpanParser;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.39';

use Markdent::Event::AutoLink;
use Markdent::Event::LineBreak;

use Moose::Role;

with 'Markdent::Role::Dialect::SpanParser';

sub _build_emphasis_start_delimiter_re {
    my $self = shift;

    return qr/(?:\*|(?<=\W)_|(?<=^)_)/;
}

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _emphasis_end_delimiter_re {
    my $self  = shift;
    my $delim = shift;

    return $delim eq '*' ? qr/\Q$delim\E/ : qr/\Q$delim\E(?=$|\W)/;
}
## use critic

around _possible_span_matches => sub {
    my $orig = shift;
    my $self = shift;

    my @look_for = $self->$orig();

    my %open = $self->_open_start_events_for_span( 'code', 'link' );
    return @look_for
        if keys %open;

    return (
        $self->$orig(),
        'bare_link',
    );
};

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _match_bare_link {
    my $self = shift;
    my $text = shift;

    return unless ${$text} =~ m{ \G
                                 (?:
                                     (?<=^)
                                     |
                                     (?<=\W)
                                 )
                                 (
                                   https?
                                   ://
                                   \S+
                                 )
                               }xgc;

    my $link = $self->_make_event( AutoLink => uri => $1 );

    $self->_markup_event($link);

    return 1;
}
## use critic

around _text_end_res => sub {
    my $orig = shift;
    my $self = shift;

    return (
        $self->$orig(),
        qr{https?://},
    );
};

1;

# ABSTRACT: Span parser for GitHub Markdown

__END__

=pod

=head1 DESCRIPTION

This role adds parsing for some of the Markdown extensions used on GitHub. See
http://github.github.com/github-flavored-markdown/ for details.

=head1 ROLES

This role does the L<Markdent::Role::Dialect::SpanParser> role.

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut
