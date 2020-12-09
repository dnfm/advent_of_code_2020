#!/usr/bin/perl

use strict;
use warnings;

no warnings qw( recursion );

my $input   = do { local $/ = undef; open my $fh, '<', 'data/9.txt'; <$fh> };
my @numbers = split m{\n}, $input;

my @original_numbers = @numbers;
my $preamble_length  = 25;
my @data_set         = map { shift @numbers } 1 .. $preamble_length;

my $invalid_number;

foreach my $number ( @numbers ) {
    if ( !is_valid( $number, @data_set ) ) {
        $invalid_number = $number;

        last;
    }

    push @data_set, $number;

    shift @data_set;
}

sub find_contiguous {
    my ( $invalid_number, $numbers, $from ) = @_;

    $from //= [];

    for ( my $idx = 0; $idx < @{ $numbers }; $idx++ ) {
        my $this_number = $numbers->[ $idx ];

        return [ @{ $from }, $this_number ] if $this_number == $invalid_number;

        return if $this_number > $invalid_number;

        my $found = find_contiguous(
            $invalid_number - $this_number,
            [ @{ $numbers }[ $idx + 1 .. @{ $numbers } - 1 ] ],
            [ @{ $from }, $this_number ],
        );

        return $found if $found;

        return if !$found && @{ $from };
    }

    return;
}

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

my $contiguous = find_contiguous( $invalid_number, \@original_numbers );
my @sorted     = sort { $a <=> $b } @{ $contiguous };

print "Sum of $sorted[0] and $sorted[-1] is: " . ( $sorted[0] + $sorted[-1] );
