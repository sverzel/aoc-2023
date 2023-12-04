#!/usr/bin/perl -w

use strict;

my ($input) = $0 =~ /^([^.]+)/;
$input .= '_input';

open my $fh, $input or die $!;

my $s1 = 0;
while (<$fh>) {
    my $p = 0;
    foreach my $t(grep /\d/, split /\s+/, join '', map($_, /\|(.*)$/)) {
	$p++ if /^Card\s+\d+:\s.*\b$t\b.*\|/;
    }

    $s1 += ($p > 0 ? 2**($p-1) : 0);
}

print "Points in total: $s1\n";
