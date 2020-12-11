#!/usr/bin/perl

use strict;
use warnings;

my $input   = do { local $/ = undef; open my $fh, '<', 'data/11.txt'; <$fh> };
my @seats   = map {[ split( m{}, $_ ) ]} split m{\n}, $input;

my $last     = q{};
my $this_one = join q{}, map { join q{}, @{ $_ } } @seats;

my $cycles   = 0;

while ( $this_one ne $last ) {
    $last = $this_one;

    $cycles++;

    @seats    = cycle( @seats );
    $this_one = join q{}, map { join q{}, @{ $_ } } @seats;
}

my $occupied = scalar grep { $_ eq '#' } map { @{ $_ } } @seats;
warn "$occupied seats are taken.\n";

sub cycle {
    my @seats = @_;

    my @after;

    for ( my $idx = 0; $idx < @seats; $idx++ ) {
        my @this_row = @{ $seats[ $idx ] };
        my @new_row;

        for ( my $seat_idx = 0; $seat_idx < @this_row; $seat_idx++ ) {
            my $seat = $this_row[ $seat_idx ];

            push @new_row, $seat eq '.'
                ? $seat
                : switch_seat( $seat, $idx, $seat_idx, @seats );
        }

        push @after, [ @new_row ];
    }

    return @after;
}

sub switch_seat {
    return $_[0] eq 'L' && adjacent_taken( @_ ) == 0 ? '#'
         : $_[0] eq '#' && adjacent_taken( @_ ) >= 5 ? 'L'
         :                                             $_[0];
}

sub adjacent_taken {
    my ( $seat, $row_index, $seat_index, @seats ) = @_;

    my @rules = (
        [  1,  0 ],
        [  0,  1 ],
        [ -1,  0 ],
        [  0, -1 ],
        [  1,  1 ],
        [ -1,  1 ],
        [ -1, -1 ],
        [  1, -1 ],
    );

    my $occupied = 0;

    foreach my $rule ( @rules ) {
        my ( $up_down, $left_right ) = @{ $rule };

        my $on_row  = $row_index;
        my $on_seat = $seat_index;

        my $iterator = sub {
            $on_row  += $up_down;
            $on_seat += $left_right;
        };

        $iterator->();

        while (    $on_row <    @seats        &&  $on_row >= 0 
               && $on_seat < @{ $seats[ 0 ] } && $on_seat >= 0 ) {

            if ( $seats[ $on_row ]->[ $on_seat ] eq '#' ) {
                $occupied++;

            }

            last if $seats[ $on_row ]->[ $on_seat ] ne '.';

            $iterator->();
        }
    }

    return $occupied;
}
