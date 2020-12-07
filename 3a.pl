#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/3.txt'; <$fh> };

my $col   = 0;
my $trees = 0;

foreach my $line ( split m{\n}, $input ) {
    if ( substr( $line, $col, 1 ) eq '#' ) {
        $trees++;
    }

    $col += 3;
    $col %= length( $line );
}

warn "I hit $trees trees.  Ouch.\n";
