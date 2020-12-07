#!/usr/bin/perl

use strict;
use warnings;

use List::Util qw( sum );

my $input = do { local $/ = undef; open my $fh, '<', 'data/7.txt'; <$fh> };
my @rules = split m{\n}, join q{}, $input;

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

my $sum = get_bags_inside( $rules{ 'shiny gold' } );

warn "Bags inside shiny gold is: $sum.\n";

sub get_bags_inside {
    my ( $rules ) = @_;

    my $rule_sum = 0;

    foreach my $rule ( keys %{ $rules } ) {
        my $inner_rule = $rules->{ $rule };

        $rule_sum += $inner_rule->[ 0 ];

        my $inside_that = get_bags_inside( $inner_rule->[ 1 ] );

        $rule_sum += $inner_rule->[ 0 ] * $inside_that;
    }

    return $rule_sum;
}
