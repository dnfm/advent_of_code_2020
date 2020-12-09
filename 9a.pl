#!/usr/bin/perl

use strict;
use warnings;

my $input   = do { local $/ = undef; open my $fh, '<', 'data/9.txt'; <$fh> };
my @numbers = split m{\n}, $input;

my $preamble_length = 25;
my @data_set        = map { shift @numbers } 1 .. $preamble_length;

sub is_valid {
    my ( $number, @from ) = @_;

    for ( my $idx = 0; $idx < @from; $idx++ ) {
        my $start = $from[ $idx ];

        for ( my $second_idx = $idx; $second_idx < @from; $second_idx++ ) {
            return 1 if $start + $from[ $second_idx ] == $number;
        }
    }

    return 0;
}

foreach my $number ( @numbers ) {
    die "$number is invalid!\n" if !is_valid( $number, @data_set );

    push @data_set, $number;

    shift @data_set;
}


