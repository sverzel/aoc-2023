#!/usr/bin/perl -w

use strict;

my ($input) = $0 =~ /^([^.]+)/;
$input .= '_input';

open my $fh, $input or die $!;

my $i = 1;
my $s1 = 0; my $s2 = 0;
while (<$fh>) {
    s/^Game \d+: //;
    my %s = (red => 0, green => 0, blue => 0);
    foreach my $s(split /\s*;\s*/) {
	foreach my $t(split /\s*,\s*/, $s) {
	    my ($n, $color) = split /\s+/, $t;
	    $s{$color} = $n if $n > $s{$color};
	}
    }

    $s1 += $i if $s{red} <= 12 && $s{green} <= 13 && $s{blue} <= 14;
    $s2 += $s{red} * $s{green} * $s{blue};

    $i++;
}

print "Sum of game ID's: $s1\n";
print "Sum of power of sets: $s2\n";
