#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/6.txt'; <$fh> };

my @groups = split m{\n\n}, $input;

my $total = 0;

foreach my $group ( @groups ) {
    my %answered;

    foreach my $person ( split m{\n}, $group ) {
        $answered{ $_ }++ for split m{}, $person;
    }

    $total += scalar keys %answered;
}

warn "$total\n";
