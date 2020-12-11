#!/usr/bin/perl

use strict;
use warnings;

my $input   = do { local $/ = undef; open my $fh, '<', 'data/11.txt'; <$fh> };
my @seats   = map {[ '.', split( m{}, $_ ), '.' ]} split m{\n}, $input;

unshift @seats, [ ('.') x scalar @{ $seats[0] } ];
push    @seats, [ ('.') x scalar @{ $seats[0] } ];

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

    my @after = $seats[ 0 ];

    for ( my $idx = 1; $idx < @seats - 1; $idx++ ) {
        my @this_row = @{ $seats[ $idx ] };

        my @new_row = '.';

        for ( my $seat_idx = 1; $seat_idx < @this_row - 1; $seat_idx++ ) {
            my $seat = $this_row[ $seat_idx ];

            push @new_row, $seat eq '.'
                ? $seat
                : switch_seat( $seat, $seat_idx, map { $seats[ $_ ] }
                                                     $idx - 1 .. $idx + 1 );
        }

        push @after, [ @new_row, '.' ];
    }

    push @after, $seats[ -1 ];

    return @after;
}

sub switch_seat {
    return $_[0] eq 'L' && adjacent_taken( @_ ) == 0 ? '#'
         : $_[0] eq '#' && adjacent_taken( @_ ) >= 4 ? 'L'
         :                                             $_[0];
}

sub adjacent_taken {
    my ( $seat, $index, $prev, $row, $next ) = @_;

    my $taken = 0;

    $taken++ for grep { $_ }
        $prev->[ $index - 1 ] eq '#',
        $prev->[ $index     ] eq '#',
        $prev->[ $index + 1 ] eq '#',
         $row->[ $index - 1 ] eq '#',
         $row->[ $index + 1 ] eq '#',
        $next->[ $index - 1 ] eq '#',
        $next->[ $index     ] eq '#',
        $next->[ $index + 1 ] eq '#';

    return $taken;
}
