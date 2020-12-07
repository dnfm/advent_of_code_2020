#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/2.txt'; <$fh> };

my $valid_passwords = 0;

foreach my $rule ( split m{\n}, $input ) {
    my ( $min, $max, $letter, $password )
        = $rule =~ m{(\d+)-(\d+)\s+(\w):\s+(\S+)};

    my @seen_count = $password =~ m{($letter)}g;
    
    $valid_passwords++ if @seen_count >= $min && @seen_count <= $max;
}

warn "There are $valid_passwords valid passwords in the data set.\n";
