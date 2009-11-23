use strict;
use warnings;

use Test::More;

plan 'no_plan';

use lib 't/lib';

use File::Basename qw( basename );
use File::Find qw( find );
use File::Slurp qw( read_file );
use Test::Markdent;

my @md_files;
find(
    sub {
        push @md_files, $File::Find::name
            if $File::Find::name =~ /\.text$/;
    },
    't/mdtest-data'
);

for my $md_file ( sort @md_files ) {
    ( my $html_file = $md_file ) =~ s/\.text$/.xhtml/;

    next unless -f $html_file;

    my $markdown    = read_file($md_file);
    my $expect_html = read_file($html_file);

    my $desc = basename($md_file);
    $desc =~ s/\.text$//;

    html_output_ok( $markdown, $expect_html, $desc );
}
