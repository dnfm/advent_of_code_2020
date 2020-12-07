#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/1.txt'; <$fh> };

my @seen;

foreach my $number ( split m{\n}, $input ) {
    foreach my $seen_number_1 ( @seen ) {
        next if $number + $seen_number_1 >= 2020;

        foreach my $seen_number_2 ( @seen ) {
            next if $seen_number_2 == $seen_number_1;

            die $seen_number_1 * $seen_number_2 * $number
                if $number + $seen_number_1 + $seen_number_2 == 2020;
        }
    }

    push @seen, $number;
}
