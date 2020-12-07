#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/5.txt'; <$fh> };

my $highest_seat_id = 0;
my $lowest_seat_id  = 999999999999;

my %seen;

foreach my $input ( split m{\n}, $input ) {
    my ( $row  ) = $input =~ m{([FB]+)};
    my ( $seat ) = $input =~ m{([LR]+)};

    $row  =~ tr/BF/10/;
    $seat =~ tr/RL/10/;

    $row  = oct( "0b$row"  );
    $seat = oct( "0b$seat" );

    my $id = $row * 8 + $seat;

    $highest_seat_id = $id if $id > $highest_seat_id;
    $lowest_seat_id  = $id if $id < $lowest_seat_id;

    $seen{ $id } = 1;
}

for my $fine ( $lowest_seat_id .. $highest_seat_id ) {
    next if $seen{ $fine };
    die "$fine is missing.\n";
}
