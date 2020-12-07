#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/1.txt'; <$fh> };

my @seen;

foreach my $number ( split m{\n}, $input ) {
    foreach my $seen_number ( @seen ) {
        die $seen_number * $number if $number + $seen_number == 2020;
    }

    push @seen, $number;
}
