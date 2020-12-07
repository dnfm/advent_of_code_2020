#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/6.txt'; <$fh> };

my @groups = split m{\n\n}, $input;

my $total = 0;

foreach my $group ( @groups ) {
    my %answered;

    my @people = split m{\n}, $group;

    foreach my $person ( @people ) {
        $answered{ $_ }++ for split m{}, $person;
    }

    $total++ for grep { $answered{ $_ } == scalar @people } keys %answered;
}

warn "$total\n";
