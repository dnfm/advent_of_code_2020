#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/3.txt'; <$fh> };

my @rules = (
    [ 1, 1 ],
    [ 3, 1 ],
    [ 5, 1 ],
    [ 7, 1 ],
    [ 1, 2 ],
);

my @trees;

foreach my $rule ( @rules ) {
    my $trees = 0;
    my $col   = 0;
    my $row   = 0;

    foreach my $line ( split m{\n}, $input ) {
        next if $row++ % $rule->[1] != 0;

        if ( substr( $line, $col, 1 ) eq '#' ) {
            $trees++;
        }

        $col += $rule->[ 0 ];
        $col %= length( $line );
    }

    push @trees, $trees;
}

my $product = shift @trees;
$product *= $_ for @trees;

warn "Total number of trees: $product.\n";
