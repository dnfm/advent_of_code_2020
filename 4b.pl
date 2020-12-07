#!/usr/bin/perl

use strict;
use warnings;

my $input = do { local $/ = undef; open my $fh, '<', 'data/4.txt'; <$fh> };

my @people = split m{\n\n}, $input;

my $valid = 0;

my %rules = (
    byr => sub { $_ >= 1920 && $_ <= 2002 },
    iyr => sub { $_ >= 2010 && $_ <= 2020 },
    eyr => sub { $_ >= 2020 && $_ <= 2030 },
    hgt => sub {    /(\d+)cm/ && $1 >= 150 && $1 <= 193 
                 || /(\d+)in/ && $1 >=  59 && $1 <=  76 },
    hcl => sub { /^#[a-f0-9]{6}$/ },
    ecl => sub { /^(?:amb|blu|brn|gry|grn|hzl|oth)$/ },
    pid => sub { /^\d{9}$/ },
);

foreach my $person ( @people ) {
    my %parameters = map {( split m/:/, $_ )}
                         split m{\s+}, $person;

    my @passes = grep $_,
                  map { my ( $r, $v ) = @{ $_ }; $_ = $v; $r->() }
                 grep { $_->[ 1 ] }
                  map {[ $rules{ $_ }, $parameters{ $_ } ]}
                      keys %rules;

    $valid++ if scalar @passes == keys %rules;
}

warn "There are $valid valid passports in this list.\n";
