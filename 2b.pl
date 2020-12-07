#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/2.txt'; <$fh> };

my $valid_passwords = 0;

foreach my $rule ( split m{\n}, $input ) {
    my ( $l, $r, $letter, $password )
        = $rule =~ m{(\d+)-(\d+)\s+(\w):\s+(\S+)};

    my $in_l = substr( $password, $l - 1, 1 ) eq $letter;
    my $in_r = substr( $password, $r - 1, 1 ) eq $letter;

    $valid_passwords += $in_l && $in_r ? 0
                      : $in_l || $in_r ? 1
                      :                  0;
}

warn "There are $valid_passwords valid passwords in the data set.\n";
