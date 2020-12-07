#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( sum );

my $input = do { local $/ = undef; open my $fh, '<', 'data/7.txt'; <$fh> };
my @rules = split m{\n}, $input;

my %rules;

foreach my $rule ( @rules ) {
    if ( $rule =~ m{(.+) bags contain no other bags} ) {
        $rules{ $1 } = undef;
    }
    else {
        $rule =~ s/(.+) bags contain //;
        my $colour = $1;

        $rules{ $colour } = {
            map { /(\d+) (.+) bags?\b/ && ( $2, $1 ) }
                split m{, }, $rule
        };
    }
}

foreach my $colour ( keys %rules ) {
    my $colour_rule = $rules{ $colour };

    next if !defined $colour_rule;

    foreach my $colour_rule_colour ( keys %{ $colour_rule } ) {
        $colour_rule->{ $colour_rule_colour } = [
            $colour_rule->{ $colour_rule_colour },
            $rules{ $colour_rule_colour }
        ];
    }
}

my $can_hold_golden = sum check_for_golden( \%rules, 1 );

warn "Can hold golden: $can_hold_golden\n";

sub check_for_golden {
    my ( $rules, $top ) = @_;

    my $sum = 0;

    foreach my $colour_rule ( keys %{ $rules } ) {
        next if $colour_rule eq 'shiny gold' && $top;

        return 1 if $colour_rule eq 'shiny gold';

        my $rule = $rules->{ $colour_rule };

        if ( ref( $rule ) eq 'ARRAY' ) {
            $sum++ if check_for_golden( $rule->[ 1 ] );
        }
        else {
            $sum++ if check_for_golden( $rule );
        }
    }

    return $sum;
}
