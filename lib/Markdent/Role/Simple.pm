package Markdent::Role::Simple;

use strict;
use warnings;
use namespace::autoclean;

our $VERSION = '0.26';

use Encode qw( decode );
use Markdent::Parser;

use Moose::Role;

requires 'markdown_to_html';

around markdown_to_html => sub {
    my $orig = shift;
    my $self = shift;
    my %p    = @_;

    # XXX - should warn eventually.
    $p{dialects} = delete $p{dialect}
        if exists $p{dialect};

    return $self->$orig(%p);
};

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _parse_markdown {
    my $self          = shift;
    my $markdown      = shift;
    my $dialects      = shift;
    my $handler_class = shift;
    my $handler_p     = shift;

    my $capture = q{};

    ## no critic (InputOutput::RequireBriefOpen)
    open my $fh, '>:encoding(UTF-8)', \$capture
        or die $!;

    my $handler = $handler_class->new(
        %{ $handler_p || {} },
        output => $fh,
    );

    my $parser
        = Markdent::Parser->new( dialects => $dialects, handler => $handler );

    $parser->parse( markdown => $markdown );

    close $fh
        or die $!;

    return decode( 'UTF-8', $capture );
}

1;

# ABSTRACT: A role for simple markdown to html converter classes

__END__

=pod

=head1 DESCRIPTION

This role implements behavior shared by all simple markdown to html
converters.

=head1 REQUIRED METHODS

=over 4

=item * $simple->markdown_to_html(%p);

=back

=head1 BUGS

See L<Markdent> for bug reporting details.

=cut

