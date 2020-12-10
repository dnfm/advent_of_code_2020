#!/usr/bin/perl

use strict;
use warnings;

my $input   = do { local $/ = undef; open my $fh, '<', 'data/10.txt'; <$fh> };
my @numbers = sort { $a <=> $b } split m{\n}, $input;

my %diffs;
my $last_joltage = 0;

push @numbers, $numbers[ -1 ] + 3;

foreach my $number ( @numbers ) {
    $diffs{ $number - $last_joltage }++;

    $last_joltage = $number;
}

warn "The number of 1 jolt differences multiplied by 3 jolt differences is: "
   . $diffs{ 1 } * $diffs{ 3 }
   . "\n";
