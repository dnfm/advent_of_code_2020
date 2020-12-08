#!/usr/bin/perl

use strict;
use warnings;

my $input        = do { local $/ = undef; open my $fh, '<', 'data/8.txt'; <$fh> };
my @instructions = split m{\n}, $input;

for my $to_change ( 1 .. @instructions ) {
    my $index = $to_change - 1;

    local $instructions[ $index ] = $instructions[ $index ];

       $instructions[ $index ] =~ s{^nop}{jmp}
    || $instructions[ $index ] =~ s{^jmp}{nop};

    my $accumulator_when_it_ends = gets_out( @instructions );

    die "Changing the $to_change(th|st|rd) instruction let the program end "
      . "with accumulator of $accumulator_when_it_ends " . "when it ends!\n"
      if defined $accumulator_when_it_ends;
}

sub gets_out {
    my @instruction_set = @_;

    my $accumulator = 0;
    my $ptr         = 0;

    my %commands = (
        acc => sub { $accumulator += shift; $ptr++ },
        jmp => sub { $ptr         += shift         },
    );

    my %seen;

    while ( 1 ) {
        return undef if $seen{ $ptr }++;

        my $instruction            = $instruction_set[ $ptr ];
        my ( $command, $argument ) = split m{\s+}, $instruction;

        my $action = $commands{ $command } // sub { $ptr++ };

        $action->( $argument );

        last if $ptr == scalar( @instruction_set );
    }

    return $accumulator;
}
