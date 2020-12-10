#!/usr/bin/perl

use strict;
use warnings;

no warnings 'recursion';

my $input   = do { local $/ = undef; open my $fh, '<', 'data/10.txt'; <$fh> };
my @numbers = sort { $a <=> $b } split m{\n}, $input;

my @separations = separate( [ 0, @numbers ] );

my @possibilities;

foreach my $grouping ( grep { scalar @{ $_ } > 2 } @separations ) {
    if ( scalar @{ $grouping } <= 2 ) {
        push @possibilities, scalar @{ $grouping };
    }
    else {
        my $first = shift @{ $grouping };

        my $available = find_available_options( [ $first ], $grouping, $grouping->[ -1 ] );

        push @possibilities, $available;
    }
}

warn "There are " . multiplicator( \@possibilities ) . " possible combos.\n";

sub multiplicator {
    my ( $possibilities ) = @_;

    my $product = shift @{ $possibilities };

    while ( @{ $possibilities } ) {
        $product *= multiplicator( $possibilities );
    }

    return $product;
}

sub separate {
    my ( $numbers ) = @_;

    my @bits;

    my $cur_collection;

    for ( my $idx = 0; $idx < @{ $numbers } - 2; $idx++ ) {
        my $this_number = $numbers->[ $idx ];

        die "It's impossible!\n" if $numbers->[ $idx + 1 ] > $this_number + 3;

        if ( $numbers->[ $idx + 1 ] == $this_number + 3 ) {
            push @bits, [
                @{ $cur_collection }, $this_number
            ];

            $cur_collection = [];
        }
        else {
            push @{ $cur_collection }, $this_number;
        }
    }

    return ( @bits, [ @{ $cur_collection }, $numbers[ -2 ], $numbers[ -1 ] ] );
}

sub find_available_options {
    my ( $so_far, $list, $ends_at ) = @_;

    my $works = 0;

    my $from = $so_far->[ -1 ];

    while ( @{ $list } && $from + 3 >= $list->[ 0 ] ) {
        my $next = shift @{ $list };

        $works += find_available_options(
            [ @{ $so_far }, $next ], [ @{ $list } ], $ends_at
        );
    }

    $works++ if !scalar @{ $list } && $so_far->[ -1 ] == $ends_at;

    return $works;
}
