#!/usr/bin/perl

use strict;
use warnings;

my $input       = do { local $/ = undef; open my $fh, '<', 'data/8.txt'; <$fh> };
my @instructions = split m{\n}, $input;

my $accumulator = 0;
my $ptr         = 0;

my %seen;

my %commands = (
    acc => sub { $accumulator += shift; $ptr++ },
    jmp => sub { $ptr         += shift         },
);

while ( 1 ) {
    die "Accumulator is at $accumulator and we're back at instruction $ptr!"
        if $seen{ $ptr }++;

    my $instruction = $instructions[ $ptr ];

    my ( $command, $argument ) = split m{\s+}, $instruction;

    my $action = $commands{ $command } // sub { $ptr++ };

    $action->( $argument );

    last if $ptr == scalar( @instructions );
}

warn "Got out successfully.\n";
