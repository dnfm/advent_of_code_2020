#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/4.txt'; <$fh> };

my @people = split m{\n\n}, $input;

my $valid = 0;

foreach my $person ( @people ) {
    my %parameters = map {( split m/:/, $_ )}
                         split m{\s+}, $person;

    my @required = qw( byr iyr eyr hgt hcl ecl pid );

    my $valid_entries = grep defined $_, map { $parameters{ $_ } }
                                             @required;

    $valid++ if $valid_entries == 7;
}

warn "There are $valid passports in this list.\n";
