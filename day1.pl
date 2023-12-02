#!/usr/bin/perl -w

use strict;
use List::Util qw(sum);

my ($input) = $0 =~ /^([^.]+)/;
$input .= '_input';

open my $fh, $input or die $!;

my %m = (one => 1, two => 2, three => 3, four => 4, five => 5, six => 6, seven => 7, eight => 8, nine => 9);
my (@numbers_1, @numbers_2);

while (<$fh>) {
    my @l = /(\d)/g;
    push @numbers_1, $l[0] . $l[-1];

    foreach my $n(keys %m) {
	s/$n/$n-$m{$n}-$n/g;
    }

    @l = /(\d)/g;
    push @numbers_2, $l[0] . $l[-1];
}

print "Sum (problem 1/2): ", sum(@numbers_1), "\n";
print "Sum (problem 2/2): ", sum(@numbers_2), "\n";
